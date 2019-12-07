defmodule OpenSCAD.RotateExtrude do
  use OpenSCAD.Transformation

  @type t :: %{
          angle: float(),
          convexity: integer()
        }
end
