defmodule OpenSCAD.Square do
  use OpenSCAD.Object

  @type t :: %{
          size: {integer(), integer()},
          center: boolean()
        }
end
