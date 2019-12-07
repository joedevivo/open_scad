defmodule OpenSCAD.Polyhedron do
  use OpenSCAD.Object

  @type t :: %{
          points: [{float(), float(), float()}],
          faces: [[integer()]],
          convexity: integer()
        }
end
