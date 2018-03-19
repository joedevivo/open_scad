defimpl OpenSCAD.Object, for: BitString do
  def to_scad(var) do
    :io_lib.format("~s;", [var])
      |> to_string
  end
end
