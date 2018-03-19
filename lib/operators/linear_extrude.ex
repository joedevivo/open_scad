defmodule OpenSCAD.LinearExtrude do
  @behaviour OpenSCAD.Element
  @type t :: %__MODULE__{}

  defstruct height: 0,
            center: true

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %__MODULE__{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.LinearExtrude do
  def to_scad(le) do
    "linear_extrude(height = #{le.height}, center = #{le.center})"
  end
end
