defmodule OpenSCAD.Mirror do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Mirror{}

  defstruct x: 0,
            y: 0,
            z: 0

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Mirror{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Mirror do
  def to_scad(mirror) do
    :io_lib.format("mirror([~s, ~s, ~s])",
                   [ to_string(mirror.x),
                     to_string(mirror.y),
                     to_string(mirror.z)])
    |> to_string
  end
end
