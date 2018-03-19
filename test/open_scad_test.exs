defmodule OpenSCADTest do
  use ExUnit.Case
  import OpenSCAD
  doctest OpenSCAD

  test "basic cube" do
    assert to_scad(cube(size: 2)) == "cube([2, 2, 2], center=false);\n"
    assert to_scad(cube(size: 2.0)) == "cube([2.0, 2.0, 2.0], center=false);\n"
    assert to_scad(cube(size: 2.00001)) == "cube([2.00001, 2.00001, 2.00001], center=false);\n"
  end

  test "disable cube" do
    scad = cube(size: 2)
           |> disable
    assert to_scad(scad) == "*cube([2, 2, 2], center=false);\n"
  end

  test "show_only cube" do
    scad = cube(size: 2)
           |> show_only
    assert to_scad(scad) == "!cube([2, 2, 2], center=false);\n"
  end

  test "debug cube" do
    scad = cube(size: 2)
           |> debug
    assert to_scad(scad) == "#cube([2, 2, 2], center=false);\n"
  end

  test "transparent cube" do
    scad = cube(size: 2)
           |> transparent
    assert to_scad(scad) == "%cube([2, 2, 2], center=false);\n"
  end

  test "modified translate cube" do
    scad = cube(size: 2)
           |> translate(x: 1, y: 2, z: 3)
           |> transparent
    assert to_scad(scad) == """
    %translate([1, 2, 3])
    cube([2, 2, 2], center=false);
    """
  end

  test "two cubes" do
    assert to_scad([cube(size: 2),cube(size: 3)]) == """
    cube([2, 2, 2], center=false);
    cube([3, 3, 3], center=false);
    """
  end

  test "basic translate" do
    assert to_scad(translate([cube(size: 2)],x: 1, y: 2, z: 3)) == """
    translate([1, 2, 3])
    cube([2, 2, 2], center=false);
    """

    assert to_scad(translate([cube(size: 2),cube(size: 1)],x: 1, y: 2, z: 3)) == """
    translate([1, 2, 3]) {
      cube([2, 2, 2], center=false);
      cube([1, 1, 1], center=false);
    }
    """

  end

  test "piped translate" do
    scad = cube(size: 2)
           |> translate(x: 1, y: 2, z: 3)
    assert to_scad(scad) == """
    translate([1, 2, 3])
    cube([2, 2, 2], center=false);
    """
  end

  test "indentation" do
    scad = [cube(size: 2), cube(size: 2)]
           |> translate(x: 1, y: 2, z: 3)
           |> translate(x: 4, y: 5, z: 6)
    assert to_scad(scad) == """
    translate([4, 5, 6])
    translate([1, 2, 3]) {
      cube([2, 2, 2], center=false);
      cube([2, 2, 2], center=false);
    }
    """

  end

  test "nested indentation" do
    thing1 = [cube(size: 2), cube(size: 2)]
             |> translate(x: 1, y: 2, z: 3)
             |> translate(x: 4, y: 5, z: 6)

    thing2 = [cube(size: 3), cube(size: 3)]
             |> translate(x: 1, y: 2, z: 3)
             |> translate(x: 4, y: 5, z: 6)

    scad = [thing1, thing2]
           |> translate(x: 7, y: 8, z: 9)

    assert to_scad(scad) == """
    translate([7, 8, 9]) {
      translate([4, 5, 6])
      translate([1, 2, 3]) {
        cube([2, 2, 2], center=false);
        cube([2, 2, 2], center=false);
      }
      translate([4, 5, 6])
      translate([1, 2, 3]) {
        cube([3, 3, 3], center=false);
        cube([3, 3, 3], center=false);
      }
    }
    """
  end

  test "var & $fn" do
    scad = ["$fn = 20",
            sphere(r: 1, '$fa': 1, '$fn': 2.0, '$fs': 3.1)
            |> translate(x: 3, y: 2, z: 1),
            circle(r: 1, '$fa': 1, '$fn': 2.0, '$fs': 3.1)]
    assert to_scad(scad) == """
    $fn = 20;
    translate([3, 2, 1])
    sphere(r = 1, $fa = 1, $fn = 2.0, $fs = 3.1);
    circle(r = 1, $fa = 1, $fn = 2.0, $fs = 3.1);
    """
  end

  test "cylinder" do
    assert to_scad(cylinder()) == "cylinder(h = 1, r1 = 1, r2 = 1, center = false);\n"
    assert to_scad(cylinder(h: 2)) == "cylinder(h = 2, r1 = 1, r2 = 1, center = false);\n"
    assert to_scad(cylinder(center: true)) == "cylinder(h = 1, r1 = 1, r2 = 1, center = true);\n"
    assert to_scad(cylinder(r: 2)) == "cylinder(h = 1, r1 = 2, r2 = 2, center = false);\n"
    assert to_scad(cylinder(r1: 2, r2: 4)) == "cylinder(h = 1, r1 = 2, r2 = 4, center = false);\n"
    assert to_scad(cylinder(d: 4)) == "cylinder(h = 1, r1 = 2.0, r2 = 2.0, center = false);\n"
    assert to_scad(cylinder(d1: 4, d2: 8)) == "cylinder(h = 1, r1 = 2.0, r2 = 4.0, center = false);\n"

    ## Choose r over d
    assert to_scad(cylinder(r: 2, d: 2)) == "cylinder(h = 1, r1 = 2, r2 = 2, center = false);\n"

    ## Use r for r1, and r2 for r2 if r1 not set
    assert to_scad(cylinder(r: 2, r2: 4)) == "cylinder(h = 1, r1 = 2, r2 = 4, center = false);\n"

    ## Use r for r2, and r1 for r1 if r2 not set
    assert to_scad(cylinder(r: 2, r1: 4)) == "cylinder(h = 1, r1 = 4, r2 = 2, center = false);\n"

    ## Use r for r1, d2/ for r2
    assert to_scad(cylinder(d: 100, r: 2, d2: 10)) == "cylinder(h = 1, r1 = 2, r2 = 5.0, center = false);\n"
  end

  test "polyhedron" do
    ## TODO
    ## assert to_scad(polyhedron()) == "polyhedron(convexity = 1);\n"
    cubePoints = [
      [  0,  0,  0 ],  ##0
      [ 10,  0,  0 ],  ##1
      [ 10,  7,  0 ],  ##2
      [  0,  7,  0 ],  ##3
      [  0,  0,  5 ],  ##4
      [ 10,  0,  5 ],  ##5
      [ 10,  7,  5 ],  ##6
      [  0,  7,  5 ]]  ##7

    cubeFaces = [
      [0,1,2,3],  ## bottom
      [4,5,1,0],  ## front
      [7,6,5,4],  ## top
      [5,6,2,1],  ## right
      [6,7,3,2],  ## back
      [7,4,0,3]]  ## left
    assert to_scad(polyhedron(points: cubePoints, faces: cubeFaces)) == "polyhedron(points = [[0, 0, 0], [10, 0, 0], [10, 7, 0], [0, 7, 0], [0, 0, 5], [10, 0, 5], [10, 7, 5], [0, 7, 5]], faces = [[0, 1, 2, 3], [4, 5, 1, 0], [7, 6, 5, 4], [5, 6, 2, 1], [6, 7, 3, 2], [7, 4, 0, 3]], convexity = 1);\n"
  end

  test "text" do
    assert to_scad(text("hi!")) == "text(\"hi!\");\n"
    assert to_scad(text("hi!",
                     size: 10,
                     font: "Arial:style=Regular",
                     halign: "left",
                     valign: "baseline",
                     spacing: 1,
                     direction: "ltr",
                     language: "en",
                     script: "latin",
                     '$fn': 12)
           ) == """
           text("hi!", font = "Arial:style=Regular", halign = "left", valign = "baseline", spacing = 1, direction = "ltr", language = "en", script = "latin", $fn = 12);
           """
  end

  test "rotate" do
    scad = cube(size: 3)
           |> rotate(x: 90, y: 180, z: 270)
    assert to_scad(scad) == """
    rotate([90, 180, 270])
    cube([3, 3, 3], center=false);
    """
  end

  test "mirror" do
    scad = cube(size: 3)
           |> mirror(x: 1)
    assert to_scad(scad) == """
    mirror([1, 0, 0])
    cube([3, 3, 3], center=false);
    """
  end

  test "union" do
    scad = [cube(width: 3, depth: 4, height: 5), cube(width: 5, depth: 4, height: 3)]
           |> union
    assert to_scad(scad) == """
    union() {
      cube([3, 4, 5], center=false);
      cube([5, 4, 3], center=false);
    }
    """
  end

  test "differnece" do
    scad = [cube(width: 3, depth: 4, height: 5),
            cube(width: 5, depth: 4, height: 3)]
           |> difference
    assert to_scad(scad) == """
    difference() {
      cube([3, 4, 5], center=false);
      cube([5, 4, 3], center=false);
    }
    """
  end

  test "intersection" do
    scad = [cube(width: 3, depth: 4, height: 5), cube(width: 5, depth: 4, height: 3)]
           |> intersection
    assert to_scad(scad) == """
    intersection() {
      cube([3, 4, 5], center=false);
      cube([5, 4, 3], center=false);
    }
    """
  end

  test "hull" do
    scad = [cube(width: 3, depth: 4, height: 5), cube(width: 5, depth: 4, height: 3)]
           |> hull
    assert to_scad(scad) == """
    hull() {
      cube([3, 4, 5], center=false);
      cube([5, 4, 3], center=false);
    }
    """
  end

  test "minkowski" do
    scad = [cube(width: 3, depth: 4, height: 5), cube(width: 5, depth: 4, height: 3)]
           |> minkowski
    assert to_scad(scad) == """
    minkowski() {
      cube([3, 4, 5], center=false);
      cube([5, 4, 3], center=false);
    }
    """
  end

end
