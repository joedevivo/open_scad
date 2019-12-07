defmodule OpenSCAD.Resize do
  use OpenSCAD.Transformation

  @type t :: %{
          newsize: {float(), float(), float()},
          auto: boolean()
        }
end
