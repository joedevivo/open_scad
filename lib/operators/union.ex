defmodule OpenSCAD.Union do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Union{}

  defstruct([])

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Union{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Union do
  def to_scad(_union) do
    "union()"
  end
end
