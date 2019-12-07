defmodule OpenSCAD do
  @moduledoc """
  'use OpenSCAD' in your module to have access to the entire OpenSCAD language

  See the OpenSCAD [Documentation](http://www.openscad.org/documentation.html)
  for more details of actual usage.

  This [CheatSheet](http://www.openscad.org/cheatsheet/index.html) also comes in
  handy
  """

  defmodule Language do
    # Works through all the implementations of Renderable and creates a
    # cooresponding function for its type
    defmacro __before_compile__(_env) do
      # TODO: Automate this generation
      impls = [
        OpenSCAD.Polygon,
        OpenSCAD.Square,
        OpenSCAD.Translate,
        OpenSCAD.Sphere,
        OpenSCAD.Minkowski,
        OpenSCAD.LinearExtrude,
        OpenSCAD.Import,
        OpenSCAD.Hull,
        OpenSCAD.RotateExtrude,
        OpenSCAD.Color,
        OpenSCAD.Rotate,
        OpenSCAD.Resize,
        OpenSCAD.Scale,
        OpenSCAD.Cube,
        OpenSCAD.Circle,
        OpenSCAD.Union,
        List,
        BitString,
        OpenSCAD.Intersection,
        OpenSCAD.Cylinder,
        OpenSCAD.Text,
        OpenSCAD.Offset,
        OpenSCAD.Difference,
        OpenSCAD.Mirror,
        OpenSCAD.Polyhedron
      ]

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
              # special handling for difference, just feels nicer to me
              if name == :difference do
                quote do
                  def difference(children), do: struct(unquote(i), children: children)

                  def difference(thing, things_to_remove) when is_list(things_to_remove) do
                    struct(unquote(i), children: [thing | things_to_remove])
                  end

                  def difference(thing, things_to_remove) do
                    struct(unquote(i), children: [thing, things_to_remove])
                  end
                end
              else
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
              end

            _ ->
              # This covers our implementation for BitString, :list, and Any for which we don't
              # need any additional functions.
              nil
          end
        end
        |> Enum.filter(&(not is_nil(&1)))

      scad_functions
    end
  end

  @before_compile OpenSCAD.Language

  defmacro __using__(_opts) do
    quote do
      # , only: [write: 2, to_scad: 1]
      import OpenSCAD, except: [import: 1]
      import OpenSCAD.Action, only: [disable: 1, show_only: 1, debug: 1, transparent: 1]
      @before_compile OpenSCAD
    end
  end

  # Works through all the implementations of Renderable and creates a
  # cooresponding function for its type
  defmacro __before_compile__(_env) do
    quote do
      # once you `use OpenSCAD`, you're declaring yourself a Model
      def is_open_scad_model?, do: true
    end
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
