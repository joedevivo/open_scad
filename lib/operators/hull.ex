defmodule OpenSCAD.Hull do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Hull{}

  defstruct([])

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Hull{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Hull do
  def to_scad(_hull) do
    "hull()"
  end
end
