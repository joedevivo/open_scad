defmodule OpenSCAD.Projection do
  @moduledoc """
  Projection will turn a 3D shape into a 2D shape.
    - `cut: true` will use the slice at z=0
    - `cut: false` will use all points, maybe like a shadow from 0,0,100000
  """
  use OpenSCAD.Transformation

  @type t :: %{
          cut: boolean()
        }
end
