defmodule OpenSCAD.Sphere do
  use OpenSCAD.Object

  @type t :: %{
          r: float(),
          d: float(),
          _fa: float(),
          _fn: integer(),
          _fs: float()
        }
end
