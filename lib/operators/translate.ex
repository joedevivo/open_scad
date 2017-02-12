defmodule OpenSCAD.Translate do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Translate{}

  defstruct x: 0, 
            y: 0, 
            z: 0

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Translate{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Translate do
  def to_scad(translate) do
    :io_lib.format("translate([~s, ~s, ~s])", 
                   [ to_string(translate.x), 
                     to_string(translate.y), 
                     to_string(translate.z)])
    |> to_string
  end
end