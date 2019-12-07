defmodule OpenSCAD.LinearExtrude do
  use OpenSCAD.Transformation

  @type t :: %{
          height: float(),
          center: boolean(),
          convexity: integer(),
          twist: float(),
          slices: integer(),
          scale: float(),
          _fn: integer()
        }
end
