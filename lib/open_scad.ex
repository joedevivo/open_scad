defmodule OpenSCAD do
  @moduledoc """
  'use OpenSCAD' in your module to have access to the entire OpenSCAD language

  See the OpenSCAD [Documentation](http://www.openscad.org/documentation.html)
  for more details of actual usage.

  This [CheatSheet](http://www.openscad.org/cheatsheet/index.html) also comes in
  handy
  """
  defmacro __using__(_opts) do
    quote do
      import OpenSCAD, only: [write: 2, to_scad: 1]
      import OpenSCAD.Action, only: [disable: 1, show_only: 1, debug: 1, transparent: 1]
      @before_compile OpenSCAD
    end
  end

  # Works through all the implementations of Renderable and creates a
  # cooresponding function for its type
  defmacro __before_compile__(_env) do
    impls =
      case OpenSCAD.Renderable.__protocol__(:impls) do
        {:consolidated, x} ->
          List.delete(x, Any)

        # dialyzer says this can't ever match, because by the time dialyzer sees
        # it, it's been consolidated. THAT'S NOT HOW THE REAL WORLD WORKS
        # DIALYZER!
        :not_consolidated ->
          raise "Not Consolidated"
      end

    scad_functions =
      for i <- impls do
        name = OpenSCAD.Action.scad_name(i) |> String.to_atom()

        case OpenSCAD.Renderable.type(%{__struct__: i}) do
          # If this impl is an object, create a function that only takes
          # parameters.
          :object ->
            quote do
              def unquote(name)(kwlist \\ []) do
                struct(unquote(i), kwlist)
              end
            end

          # If it's a transformation, create a function that can have child
          # objects piped into the first argument
          :transformation ->
            quote do
              def unquote(name)(children, kwlist \\ [])

              # allows us to render a transformation with no children. This has
              # no effect, but OpenSCAD is fine with it, so must we be.
              def unquote(name)(nil, kwlist) do
                unquote(name)([], kwlist)
              end

              def unquote(name)(obj, kwlist) do
                struct(unquote(i), [children: obj] ++ kwlist)
              end
            end

          _ ->
            # This covers our implementation for BitString, :list, and Any for which we don't
            # need any additional functions.
            nil
        end
      end
      |> Enum.filter(&(not is_nil(&1)))

    scad_functions ++
      [
        quote do
          # once you `use OpenSCAD`, you're declaring yourself a Model
          def is_open_scad_model?, do: true
        end
      ]
  end

  @doc """
  Renders an OpenSCAD.Renderable to a string with a trailing newline.
  """
  @spec to_scad(any) :: String.t()
  def to_scad(renderable) do
    OpenSCAD.Renderable.to_scad(renderable) <> "\n"
  end

  @doc """
  Writes an OpenSCAD.Renderable out to a file
  """
  @spec write(any, Path.t()) :: :ok | {:error, atom}
  def write(renderable, filename) do
    scad = to_scad(renderable)
    File.write(filename, scad)
  end
end
