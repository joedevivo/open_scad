defmodule OpenSCAD.Mirror do
  use OpenSCAD.Transformation

  @type t :: %{
          v: {float(), float(), float()}
        }
end
