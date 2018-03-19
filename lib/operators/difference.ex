defmodule OpenSCAD.Difference do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Difference{}

  defstruct([])

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Difference{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Difference do
  def to_scad(_difference) do
    "difference()"
  end
end
