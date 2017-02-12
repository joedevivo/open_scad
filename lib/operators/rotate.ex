defmodule OpenSCAD.Rotate do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Rotate{}

  ## TODO: Rotate around a specific axis
  ## https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#rotate
  ## contains a form for not rotating around the origin. I imagine this will 
  ## be hard to use, as we don't really track absolute position once a thing 
  ## moves. OpenSCAD doesn't either!
  defstruct x: 0, 
            y: 0, 
            z: 0

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Rotate{},
      params,
      [])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Rotate do
  def to_scad(rotate) do
    :io_lib.format("rotate([~s, ~s, ~s])", 
                   [ to_string(rotate.x), 
                     to_string(rotate.y), 
                     to_string(rotate.z)])
    |> to_string
  end
end