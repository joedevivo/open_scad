defmodule OpenSCAD.Polygon do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Polygon{}

  defstruct points: nil,
            paths: nil,
            convexity: 1

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Polygon{},
      params)
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Polygon do
  def to_scad(p) do
    :io_lib.format("polygon(points = ~s, paths = ~s, convexity = ~s);",
                   [inspect(p.points),
                    inspect(p.paths),
                    to_string(p.convexity)])
    |> to_string
  end
end
