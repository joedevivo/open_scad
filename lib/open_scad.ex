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
        OpenSCAD.Projection,
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

  @doc """
  slice is something unavailable in openscad.

  It's intention is to take a 3D model and output a set of SVGs that will be
  individual layers that can be cut with a laser or CNC machine.

  You can play around with these settings to distort the model, but if you want
  it to be accurate, set `layer` to the thickness of your material.

  Also, it shift the model z -layer mm for each step, and will create the svg
  from all points at z=0 for that step. This means that it starts at z=0, and
  anything below z=0 will not be accounted for at all. Also, it will only go as
  high as `height`, so if you create a `cube(v: [100, 100, 100], center:true)`,
  half of it will be below the z axis and never get rendered. It will have 50mm
  above the z-axis, but if you set `height` to `25`, you'll lose the topp half
  of that. Conversley, if you set `height` to `100`, you'll end up with half
  your SVGs being empty.

  - height: total height in mm
  - layer: height per layer
  - name: file_prefix
  """
  # TODO: After each SVG is created, read it and if it's empty abort the
  # process, since if you're stacking layers and a layer is empty, you can't
  # stack any higher.
  @spec slice(any(), Keyword.t()) :: :ok
  def slice(renderable, kwargs) do
    layer_count = floor(kwargs[:height] / kwargs[:layer])

    layer_digits =
      layer_count
      |> Integer.to_string()
      |> String.length()

    _ = File.mkdir_p(kwargs[:name])

    _ = write(renderable, Path.join(kwargs[:name], "model.scad"))

    Range.new(0, layer_count)
    |> Enum.each(fn l ->
      filename = String.pad_leading(Integer.to_string(l), layer_digits, "0")
      scad_file = Path.join(kwargs[:name], Enum.join([filename, ".scad"]))
      svg_file = Path.join(kwargs[:name], Enum.join([filename, ".svg"]))

      _ =
        renderable
        |> translate(v: [0, 0, -(kwargs[:layer] * l)])
        |> projection(cut: true)
        |> write(scad_file)

      {output, rc} = System.cmd("openscad", ["-o", svg_file, scad_file])

      if rc != 0 do
        IO.puts(output)
      end

      :ok
    end)

    :ok
  end
end
