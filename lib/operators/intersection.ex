defmodule OpenSCAD.Intersection do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Intersection{}

  defstruct([]) 

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Intersection{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Intersection do
  def to_scad(_intersection) do
    "intersection()"
  end
end