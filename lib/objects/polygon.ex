defmodule OpenSCAD.Polygon do
  use OpenSCAD.Object

  @type t :: %{
          points: [{float(), float()}],
          paths: [[integer()]],
          convexity: integer()
        }
end
