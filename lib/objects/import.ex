defmodule OpenSCAD.Import do
  use OpenSCAD.Object

  @type t :: %{
          file: String.t(),
          convexity: integer(),
          layer: integer()
        }
end
