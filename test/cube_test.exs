defmodule OpenSCAD.CubeTest do
  use ExUnit.Case

  alias OpenSCAD.{Cube, Renderable}

  test "cube rendering" do
    cube =
      %Cube{
        size: {1, 2, 3},
        center: true
      }
      |> Renderable.to_scad()

    assert cube == "cube(center = true, size = [1, 2, 3]);"
    assert Renderable.to_scad(%Cube{}) == "cube();"
    assert Renderable.to_scad(%Cube{center: false}) == "cube(center = false);"
    assert Renderable.to_scad(%Cube{size: {3, 2, 1}}) == "cube(size = [3, 2, 1]);"
  end
end
