defmodule OpenSCAD.Color do
  use OpenSCAD.Transformation

  @type t :: %{
          c:
            {integer(), integer(), integer(), float()}
            | {integer(), integer(), integer()}
            | String.t(),
          alpha: float()
        }
end
