defmodule OpenSCAD.Circle do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Circle{}

  defstruct r: 1,
            '$fa': nil,
            '$fs': nil,
            '$fn': nil

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Circle{},
      params,
      [
        { :d , &(%{&1 | r: &2/2})}
      ])
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Circle do
  def to_scad(c) do
    :io_lib.format("circle(r = ~s~s~s~s);",
                   [to_string(c.r),
                    OpenSCAD.Element.maybe_format(c, :'$fa', &to_string/1),
                    OpenSCAD.Element.maybe_format(c, :'$fn', &to_string/1),
                    OpenSCAD.Element.maybe_format(c, :'$fs', &to_string/1)
                    ])
    |> to_string
  end
end
