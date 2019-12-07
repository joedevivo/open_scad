defmodule OpenSCAD.Cube do
  @moduledoc """
  Cube will be our canonical object for testing metaprogramming
  """
  use OpenSCAD.Object

  @type t :: %{
          size: float() | {float(), float(), float()},
          center: boolean()
        }
end
