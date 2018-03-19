defmodule OpenSCAD.Sphere do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Sphere{}

  defstruct r: 1,
            '$fa': nil,
            '$fs': nil,
            '$fn': nil

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Sphere{},
      params,
      [
        { :d , &(%{&1 | r1: &2/2})}
      ])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Sphere do
  def to_scad(s) do
    :io_lib.format("sphere(r = ~s~s~s~s);",
                   [to_string(s.r),
                    OpenSCAD.Element.maybe_format(s, :'$fa', &to_string/1),
                    OpenSCAD.Element.maybe_format(s, :'$fn', &to_string/1),
                    OpenSCAD.Element.maybe_format(s, :'$fs', &to_string/1)
                    ])
    |> to_string
  end
end
