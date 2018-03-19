defmodule OpenSCAD.Disable do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Disable{}

  defstruct child: nil

  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Disable{},
      params,
      [])
  end
end

defimpl OpenSCAD.Modifier, for: OpenSCAD.Disable do
  def to_scad(_m) do
    "*"
  end

  def child(m) do
    m.child
  end
end

defmodule OpenSCAD.ShowOnly do

end

defmodule OpenSCAD.Debug do

end

defmodule OpenSCAD.Transparent do

end
