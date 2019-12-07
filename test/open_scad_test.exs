defmodule OpenSCADTest do
  use ExUnit.Case
  use OpenSCAD
  alias OpenSCAD.Renderable, as: NOCR
  doctest OpenSCAD

  test "basic cube" do
    assert NOCR.to_scad(cube(size: 2)) == "cube(size = 2);"
    assert NOCR.to_scad(cube(size: 2.0)) == "cube(size = 2.0);"
    assert NOCR.to_scad(cube(size: 2.00001)) == "cube(size = 2.00001);"
  end

  test "disable cube" do
    scad =
      cube(size: 2)
      |> disable

    assert NOCR.to_scad(scad) == "*cube(size = 2);"
  end

  test "show_only cube" do
    scad =
      cube(size: 2)
      |> show_only

    assert NOCR.to_scad(scad) == "!cube(size = 2);"
  end

  test "debug cube" do
    scad =
      cube(size: 2)
      |> debug

    assert NOCR.to_scad(scad) == "#cube(size = 2);"
  end

  test "transparent cube" do
    scad =
      cube(size: 2)
      |> transparent

    assert NOCR.to_scad(scad) == "%cube(size = 2);"
  end

  test "modified translate cube" do
    scad =
      cube(size: 2)
      |> translate(v: [1, 2, 3])
      |> transparent

    assert to_scad(scad) == """
           %translate(v = [1, 2, 3]){
             cube(size = 2);
           }
           """
  end

  test "two cubes" do
    assert to_scad([cube(size: 2), cube(size: 3)]) == """
           cube(size = 2);
           cube(size = 3);
           """
  end

  test "basic translate" do
    assert to_scad(translate([cube(size: 2)], v: [1, 2, 3])) == """
           translate(v = [1, 2, 3]){
             cube(size = 2);
           }
           """

    assert to_scad(translate([cube(size: 2), cube(size: 1)], v: [1, 2, 3])) == """
           translate(v = [1, 2, 3]){
             cube(size = 2);
             cube(size = 1);
           }
           """
  end

  test "piped translate" do
    scad =
      cube(size: 2)
      |> translate(v: [1, 2, 3])

    assert to_scad(scad) == """
           translate(v = [1, 2, 3]){
             cube(size = 2);
           }
           """
  end

  test "indentation" do
    scad =
      [cube(size: 2), cube(size: 2)]
      |> translate(v: [1, 2, 3])
      |> translate(v: [4, 5, 6])

    assert to_scad(scad) == """
           translate(v = [4, 5, 6]){
             translate(v = [1, 2, 3]){
               cube(size = 2);
               cube(size = 2);
             }
           }
           """
  end

  test "nested indentation" do
    thing1 =
      [cube(size: 2), cube(size: 2)]
      |> translate(v: [1, 2, 3])
      |> translate(v: [4, 5, 6])

    thing2 =
      [cube(size: 3), cube(size: 3)]
      |> translate(v: [1, 2, 3])
      |> translate(v: [4, 5, 6])

    scad =
      [thing1, thing2]
      |> translate(v: [7, 8, 9])

    assert to_scad(scad) == """
           translate(v = [7, 8, 9]){
             translate(v = [4, 5, 6]){
               translate(v = [1, 2, 3]){
                 cube(size = 2);
                 cube(size = 2);
               }
             }
             translate(v = [4, 5, 6]){
               translate(v = [1, 2, 3]){
                 cube(size = 3);
                 cube(size = 3);
               }
             }
           }
           """
  end

  test "var & $fn" do
    scad = [
      "$fn = 20;",
      sphere(r: 1, _fa: 1, _fn: 2.0, _fs: 3.1)
      |> translate(v: [3, 2, 1]),
      circle(r: 1, _fa: 1, _fn: 2.0, _fs: 3.1)
    ]

    assert to_scad(scad) == """
           $fn = 20;
           translate(v = [3, 2, 1]){
             sphere($fa = 1, $fn = 2.0, $fs = 3.1, r = 1);
           }
           circle($fa = 1, $fn = 2.0, $fs = 3.1, r = 1);
           """
  end

  test "cylinder" do
    assert NOCR.to_scad(cylinder()) == "cylinder();"
    assert NOCR.to_scad(cylinder(h: 2)) == "cylinder(h = 2);"
    assert NOCR.to_scad(cylinder(center: true)) == "cylinder(center = true);"
    assert NOCR.to_scad(cylinder(r: 2)) == "cylinder(r = 2);"
    assert NOCR.to_scad(cylinder(r1: 2, r2: 4)) == "cylinder(r1 = 2, r2 = 4);"
    assert NOCR.to_scad(cylinder(d: 4)) == "cylinder(d = 4);"
    assert NOCR.to_scad(cylinder(d1: 4, d2: 8)) == "cylinder(d1 = 4, d2 = 8);"

    ## make no judgement of the following:
    # r over d
    assert NOCR.to_scad(cylinder(r: 2, d: 2)) == "cylinder(d = 2, r = 2);"

    # Use r for r1, and r2 for r2 if r1 not set
    assert NOCR.to_scad(cylinder(r: 2, r2: 4)) == "cylinder(r = 2, r2 = 4);"

    ## Use r for r2, and r1 for r1 if r2 not set
    assert NOCR.to_scad(cylinder(r: 2, r1: 4)) == "cylinder(r = 2, r1 = 4);"

    ## Use r for r1, d2/ for r2
    assert NOCR.to_scad(cylinder(d: 100, r: 2, d2: 10)) == "cylinder(d = 100, d2 = 10, r = 2);"
  end

  test "polyhedron" do
    cubePoints = [
      ## 0
      [0, 0, 0],
      ## 1
      [10, 0, 0],
      ## 2
      [10, 7, 0],
      ## 3
      [0, 7, 0],
      ## 4
      [0, 0, 5],
      ## 5
      [10, 0, 5],
      ## 6
      [10, 7, 5],
      ## 7
      [0, 7, 5]
    ]

    cubeFaces = [
      ## bottom
      [0, 1, 2, 3],
      ## front
      [4, 5, 1, 0],
      ## top
      [7, 6, 5, 4],
      ## right
      [5, 6, 2, 1],
      ## back
      [6, 7, 3, 2],
      ## left
      [7, 4, 0, 3]
    ]

    assert to_scad(polyhedron(points: cubePoints, faces: cubeFaces, convexity: 1)) == """
           polyhedron(convexity = 1, faces = [[0, 1, 2, 3], [4, 5, 1, 0], [7, 6, 5, 4], [5, 6, 2, 1], [6, 7, 3, 2], [7, 4, 0, 3]], points = [[0, 0, 0], [10, 0, 0], [10, 7, 0], [0, 7, 0], [0, 0, 5], [10, 0, 5], [10, 7, 5], [0, 7, 5]]);
           """
  end

  test "text" do
    assert NOCR.to_scad(text(text: "hi!")) == "text(text = \"hi!\");"

    assert to_scad(
             text(
               text: "hi!",
               size: 10,
               font: "Arial:style=Regular",
               halign: "left",
               valign: "baseline",
               spacing: 1,
               direction: "ltr",
               language: "en",
               script: "latin",
               _fn: 12
             )
           ) == """
           text($fn = 12, direction = "ltr", font = "Arial:style=Regular", halign = "left", language = "en", script = "latin", size = 10, spacing = 1, text = "hi!", valign = "baseline");
           """
  end

  test "rotate" do
    scad =
      cube(size: 3)
      |> rotate(v: [90, 180, 270])

    assert to_scad(scad) == """
           rotate(v = [90, 180, 270]){
             cube(size = 3);
           }
           """
  end

  test "mirror" do
    scad =
      cube(size: 3)
      |> mirror(v: [1, 0, 0])

    assert to_scad(scad) == """
           mirror(v = [1, 0, 0]){
             cube(size = 3);
           }
           """
  end

  test "union" do
    scad =
      [cube(size: [3, 4, 5]), cube(size: [5, 4, 3])]
      |> union

    assert to_scad(scad) == """
           union(){
             cube(size = [3, 4, 5]);
             cube(size = [5, 4, 3]);
           }
           """
  end

  test "differnece" do
    scad =
      [cube(size: [3, 4, 5]), cube(size: [5, 4, 3])]
      |> difference

    assert to_scad(scad) == """
           difference(){
             cube(size = [3, 4, 5]);
             cube(size = [5, 4, 3]);
           }
           """
  end

  test "intersection" do
    scad =
      [cube(size: [3, 4, 5]), cube(size: [5, 4, 3])]
      |> intersection

    assert to_scad(scad) == """
           intersection(){
             cube(size = [3, 4, 5]);
             cube(size = [5, 4, 3]);
           }
           """
  end

  test "hull" do
    scad =
      [cube(size: [3, 4, 5]), cube(size: [5, 4, 3])]
      |> hull

    assert to_scad(scad) == """
           hull(){
             cube(size = [3, 4, 5]);
             cube(size = [5, 4, 3]);
           }
           """
  end

  test "minkowski" do
    scad =
      [cube(size: [3, 4, 5]), cube(size: [5, 4, 3])]
      |> minkowski

    assert to_scad(scad) == """
           minkowski(){
             cube(size = [3, 4, 5]);
             cube(size = [5, 4, 3]);
           }
           """
  end
end
