defmodule OpenSCAD.Cube do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Cube{}

  defstruct width: 1, 
            depth: 1, 
            height: 1, 
            center: false
  
  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Cube{},
      params,
      [
        { :size , &(%{&1 | width: &2, 
                           height: &2,
                           depth: &2})},
        { :x, &(%{&1 | width: &2})},
        { :y, &(%{&1 | depth: &2})},
        { :z, &(%{&1 | height: &2})}
      ])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Cube do
  def to_scad(cube) do
    :io_lib.format("cube([~s, ~s, ~s], center=~p);", 
                  [to_string(cube.width), 
                   to_string(cube.depth), 
                   to_string(cube.height), 
                   cube.center])
      |> to_string
  end 
end