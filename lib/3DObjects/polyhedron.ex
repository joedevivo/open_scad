defmodule OpenSCAD.Polyhedron do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Polyhedron{}

  defstruct points: nil,
            faces: nil,
            convexity: 1
  
  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Polyhedron{},
      params)
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Polyhedron do
  def to_scad(p) do
    :io_lib.format("polyhedron(points = ~s, faces = ~s, convexity = ~s);", 
                   [inspect(p.points),
                    inspect(p.faces),
                    to_string(p.convexity)]) 
    |> to_string
  end 
end