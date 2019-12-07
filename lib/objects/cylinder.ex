defmodule OpenSCAD.Cylinder do
  use OpenSCAD.Object

  @type t :: %{
          h: float(),
          r: float(),
          r1: float(),
          r2: float(),
          d: float(),
          d1: float(),
          d2: float(),
          center: boolean(),
          _fa: float(),
          _fs: float(),
          _fn: integer()
        }
end
