defmodule OpenSCAD.Square do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Square{}

  defstruct width: 1, 
            depth: 1,  
            center: false
  
  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Square{},
      params,
      [
        { :size , &(%{&1 | width: &2, 
                           height: &2,
                           depth: &2})}
      ])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Square do
  def to_scad(square) do
    :io_lib.format("square(size = [~s, ~s], center=~p);", 
                  [to_string(square.width), 
                   to_string(square.depth), 
                   square.center])
      |> to_string
  end 
end