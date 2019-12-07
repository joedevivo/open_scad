defmodule OpenSCAD.Offset do
  use OpenSCAD.Transformation

  @type t :: %{
          r: float(),
          delta: float(),
          chamfer: boolean()
        }
end
