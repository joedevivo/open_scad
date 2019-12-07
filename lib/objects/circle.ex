defmodule OpenSCAD.Circle do
  use OpenSCAD.Object

  @type t :: %{
          r: integer(),
          d: integer(),
          _fa: float(),
          _fs: float(),
          _fn: integer()
        }
end
