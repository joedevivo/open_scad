defmodule OpenSCAD.Translate do
  @moduledoc """
  Translate will be our canonical operator for testing metaprogramming
  """
  use OpenSCAD.Transformation

  @type t :: %{
          v: {float(), float(), float()}
        }
end
