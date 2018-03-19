defmodule OpenSCAD.Minkowski do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Minkowski{}

  defstruct([])

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Minkowski{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Minkowski do
  def to_scad(_m) do
    "minkowski()"
  end
end
