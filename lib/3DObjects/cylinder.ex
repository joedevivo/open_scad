defmodule OpenSCAD.Cylinder do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Cylinder{}

  defstruct h: 1, 
            r1: 1, 
            r2: 1, 
            center: false,
            '$fa': nil, 
            '$fs': nil, 
            '$fn': nil

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Cylinder{},
      params,
      [
        { :d , &(%{&1 | r1: &2/2, r2: &2/2})},
        { :r , &(%{&1 | r1: &2, r2: &2})},
        { :d1, &(%{&1 | r1: &2/2})},
        { :d2, &(%{&1 | r2: &2/2})}
      ])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Cylinder do
  import OpenSCAD.Element
  def to_scad(cylinder) do
    :io_lib.format("cylinder(h = ~s, r1 = ~s, r2 = ~s, center = ~s~s~s~s);", 
                  [to_string(cylinder.h),
                   to_string(cylinder.r1),
                   to_string(cylinder.r2), 
                   to_string(cylinder.center),
                   maybe_format(cylinder, :'$fa', &to_string/1),
                   maybe_format(cylinder, :'$fn', &to_string/1),
                   maybe_format(cylinder, :'$fs', &to_string/1)])
      |> to_string
  end 
end