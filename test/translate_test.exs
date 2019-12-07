defmodule OpenSCAD.TranslateTest do
  use ExUnit.Case
  use OpenSCAD

  alias OpenSCAD.{Renderable, Translate}

  @doc """
  This is pretty pointless SCAD, but it is syntactically valid, so we test that
  it can be generated. It will render absolutely nothing

  ```
  Normalized CSG tree has 0 elements
  ```
  """
  test "render translate" do
    assert Renderable.to_scad(%Translate{v: {1, 2, 3}}) ==
             "translate(v = [1, 2, 3]){\n}"

    assert translate([], v: {1, 2, 3}) ==
             %Translate{v: {1, 2, 3}}

    assert translate(nil, v: {1, 2, 3}) ==
             %Translate{v: {1, 2, 3}}
  end
end
