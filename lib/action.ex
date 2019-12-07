defmodule OpenSCAD.Action do
  @moduledoc """
  An Action is anything that can be rendered. It can be an object or a series
  of operators that end in an object, but it must end, which means a chain of
  operators is not an Action, but would be once an object is fed to it.
  """

  # Right now it does nothing except *be* a type
  defstruct []
  @type t :: %__MODULE__{}

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(
        __MODULE__,
        :__openscad_meta__,
        accumulate: true
      )

      # The fundamental difference between objects and transformations is that
      # objects don't have children.
      Module.put_attribute(
        __MODULE__,
        :__openscad_children__,
        Keyword.get(unquote(opts), :has_children, false)
      )

      # These are the arguments to the corresponding OpenSCAD function, and is
      # populated by walking the AST of the Module's @t type.
      Module.register_attribute(__MODULE__, :struct_fields, accumulate: true)
      @before_compile OpenSCAD.Action
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      # Grab all of the types
      module_types = Module.get_attribute(__MODULE__, :type)

      # Remove them, don't worry, we'll put them back
      Module.delete_attribute(__MODULE__, :type)

      # Enum.reduce will put every type back in the the @type attr
      # except `t` which we'll store in `t_type` for now, and use
      # the pattern matched fields `struct_field_types` to generate
      # the struct.
      {struct_field_types, t_type} =
        Enum.reduce(
          module_types,
          [],
          fn
            # matches :t on the `@type t` from the module
            {:type, {:"::", a, [{:t, b, c}, {:%{}, d, t}]}, e}, _acc ->
              {t,
               {:type,
                {:"::", a,
                 [
                   {:t, b, c},
                   # there's a subtle transformation happening here, what's
                   # different from the pattern match in the function clause is
                   # the addition of __MODULE__, turning the Map defined in the
                   # module's t @type into a struct with the same fields.

                   # TODO: If there's a way to declare default values in that
                   # Map, it would simplify this even further for general use.
                   {:%, d, [__MODULE__, {:%{}, d, t}]}
                 ]}, e}}

            {:type, expr, pos}, acc ->
              # This is not `@type t`, which we're using as our convention,
              # so put it back in the `:type` attribute

              # Unpublished in hexdocs, but find this
              # [here](https://github.com/elixir-lang/elixir/blob/v1.9.4/lib/elixir/lib/kernel/typespec.ex#L102-L158)
              # but here's what the args are for reference:
              # deftypespec(kind, expr, line, file, module, pos)
              # TODO: more useful values for line & file
              Kernel.Typespec.deftypespec(:type, expr, 0, "", __MODULE__, pos)
              acc
          end
        )

      Module.put_attribute(__MODULE__, :__openscad_meta__, {:t, t_type})

      Module.put_attribute(
        __MODULE__,
        :__openscad_meta__,
        {:struct_field_types, struct_field_types}
      )

      # pattern match type out of the larger tuple, so we can recreate it
      # as a struct.
      {:type, {:"::", _, [{:t, _, _}, {:%, _, _}]} = type, p} = t_type

      Enum.each(
        struct_field_types,
        fn {name, type_info} ->
          OpenSCAD.Action.__param__(__MODULE__, name, nil, type_info)
        end
      )

      if Module.get_attribute(__MODULE__, :__openscad_children__) do
        OpenSCAD.Action.__param__(__MODULE__, :children, [])
      end

      # Modifiers
      OpenSCAD.Action.__param__(__MODULE__, :disable, false)
      OpenSCAD.Action.__param__(__MODULE__, :show_only, false)
      OpenSCAD.Action.__param__(__MODULE__, :debug, false)
      OpenSCAD.Action.__param__(__MODULE__, :transparent, false)

      # Create the struct now that the params have all been stored
      # in @struct_fields
      defstruct @struct_fields
      Kernel.Typespec.deftypespec(:type, type, 0, "", __MODULE__, p)
    end
  end

  @spec __param__(module(), atom(), any(), any(), any) :: :ok
  def __param__(mod, name, default_value \\ nil, _type_info \\ nil, _opts \\ []) do
    # Create struct field
    fields = Module.get_attribute(mod, :struct_fields)

    if List.keyfind(fields, name, 0) do
      raise ArgumentError, "field/association #{inspect(name)} is already set"
    end

    Module.put_attribute(mod, :struct_fields, {name, default_value})
  end

  ## Rendering Functions

  def scad_param_value(tuple) when is_tuple(tuple) do
    Tuple.to_list(tuple)
    |> scad_param_value()
  end

  def scad_param_value(list) when is_list(list) do
    "[" <>
      (list
       |> Enum.map(&scad_param_value(&1))
       |> Enum.join(", ")) <> "]"
  end

  def scad_param_value(other), do: inspect(other)

  def scad_param({_k, nil}), do: nil

  def scad_param({k, v}) do
    k =
      case Atom.to_string(k) do
        "_" <> rest -> "$" <> rest
        other -> other
      end

    "#{k} = #{scad_param_value(v)}"
  end

  @spec scad_name(module()) :: binary
  def scad_name(module) when is_atom(module) do
    module
    |> Module.split()
    |> Enum.reverse()
    |> hd()
    |> Macro.underscore()
  end

  def scad_name(object) do
    modifiers(object) <>
      scad_name(object.__struct__)
  end

  def scad_params(object) do
    Map.from_struct(object)
    |> Map.drop([:children, :disable, :show_only, :debug, :transparent])
    |> Enum.map(&scad_param/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  def modifiers(action) do
    {action, ""}
    |> modifier(:disable)
    |> modifier(:show_only)
    |> modifier(:debug)
    |> modifier(:transparent)
    |> elem(1)
  end

  defp modifier({%{disable: true} = a, m}, :disable), do: {a, m <> "*"}
  defp modifier({%{show_only: true} = a, m}, :show_only), do: {a, m <> "!"}
  defp modifier({%{debug: true} = a, m}, :debug), do: {a, m <> "#"}
  defp modifier({%{transparent: true} = a, m}, :transparent), do: {a, m <> "%"}
  defp modifier(a, _), do: a

  # import these to have access to modifiers
  def disable(action), do: %{action | disable: true}
  def show_only(action), do: %{action | show_only: true}
  def debug(action), do: %{action | debug: true}
  def transparent(action), do: %{action | transparent: true}
end
