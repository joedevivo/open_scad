defmodule OpenSCAD.Rotate do
  use OpenSCAD.Transformation

  @type t :: %{
          a: float(),
          v: {float(), float(), float()}
        }
end
