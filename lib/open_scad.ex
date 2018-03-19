defmodule OpenSCAD do
  @moduledoc """
  Documentation for OpenSCAD.
  """

  @doc """

  Returns a string of the object in OpenSCAD

  ## Examples:

    iex> OpenSCAD.to_scad OpenSCAD.cube(size: 2)
    "cube([2, 2, 2], center=false);\\n"

  """
  def to_scad(obj) do
    OpenSCAD.Action.to_scad(obj)
  end

  ## 2D Shapes

  def circle(params \\ []) do
    OpenSCAD.Circle.new(params)
    |> OpenSCAD.Action.new
  end

  def polygon(params \\ []) do
    OpenSCAD.Polygon.new(params)
    |> OpenSCAD.Action.new
  end

  def square(params \\ []) do
    OpenSCAD.Square.new(params)
    |> OpenSCAD.Action.new
  end

  def text(txt, params \\ []) do
    OpenSCAD.Text.new([{:text, txt}| params])
    |> OpenSCAD.Action.new
  end

  @doc """
  Cube

  ## Examples

      iex> OpenSCAD.cube(size: 2)
      %OpenSCAD.Action{children: [], modifier: nil, element: %OpenSCAD.Cube{width: 2, depth: 2, height: 2, center: false}}

  """

  def cube(params \\ []) do
    OpenSCAD.Cube.new(params)
    |> OpenSCAD.Action.new
  end

  def cylinder(params \\ []) do
    OpenSCAD.Cylinder.new(params)
    |> OpenSCAD.Action.new
  end

  def polyhedron(params \\ []) do
    OpenSCAD.Polyhedron.new(params)
    |> OpenSCAD.Action.new
  end

  def sphere(params \\ []) do
    OpenSCAD.Sphere.new(params)
    |> OpenSCAD.Action.new
  end

  ## Modifiers
  def disable(children) do
    OpenSCAD.Action.modify(children, "*")
  end

  def show_only(children) do
    OpenSCAD.Action.modify(children, "!")
  end

  def debug(children) do
    OpenSCAD.Action.modify(children, "#")
  end

  def transparent(children) do
    OpenSCAD.Action.modify(children, "%")
  end

  ## Operators.

  ## They all have `children` as the first argument for
  ## easy |>ing.

  @doc """
  Translates (moves) its child elements along the specified vector, x,y,z.

  See [OpenSCAD translate()](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#translate)
  """
  def translate(children, params \\ []) do
    OpenSCAD.Action.new(
      OpenSCAD.Translate.new(params),
      children)
  end

  @doc """
  Rotates its child `x`, `y` and `z` degrees about the respective axis.

  See [OpenSCAD rotate([deg_x, deg_y, deg_z])](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#rotate)
  """
  def rotate(children, params \\ []) do
    OpenSCAD.Action.new(
      OpenSCAD.Rotate.new(params),
      children)
  end

  @doc """
  Mirrors the child element on a plane through the origin. The arguments to
  mirror() is the x,y,z vector of a plane intersecting the origin through
  which to mirror the object.

  See [OpenSCAD mirror()](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#mirror)
  """
  def mirror(children, params \\ []) do
    OpenSCAD.Action.new(
      OpenSCAD.Mirror.new(params),
      children)
  end

  @doc """
  Creates a union of all its child nodes. This is the sum of all
  children (logical or). May be used with either 2D or 3D objects, but don't mix
  them.

  See [OpenSCAD union()](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/CSG_Modelling#union)
  """
  def union(children) do
    OpenSCAD.Action.new(
      OpenSCAD.Union.new(),
      children
    )
  end

  @doc """
  See [OpenSCAD difference()](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/CSG_Modelling#difference)

  """
  def difference(children) do
    OpenSCAD.Action.new(
      OpenSCAD.Difference.new(),
      children
    )
  end

  @doc """
  Alternate syntax for difference

  ## Examples:

    iex> OpenSCAD.cube(size: 2)
    ...> |> difference(OpenSCAD.cube(size: 1))
    ...> |> OpenSCAD.to_scad
    "difference() {\\n  cube([2, 2, 2], center=false);\\n  cube([1, 1, 1], center=false);\\n}\\n"

    iex> OpenSCAD.cube(size: 3)
    ...> |> difference([OpenSCAD.cube(size: 2), OpenSCAD.cube(size: 1)])
    ...> |> OpenSCAD.to_scad
    "difference() {\\n  cube([3, 3, 3], center=false);\\n  cube([2, 2, 2], center=false);\\n  cube([1, 1, 1], center=false);\\n}\\n"

  """
  def difference(obj, things_to_remove) when is_list(things_to_remove) do
    OpenSCAD.Action.new(
      OpenSCAD.Difference.new(),
      [obj | things_to_remove]
    )
  end
  def difference(obj, things_to_remove) do
    OpenSCAD.Action.new(
      OpenSCAD.Difference.new(),
      [obj, things_to_remove]
    )
  end

  @doc """

  """
  def intersection(children) do
    OpenSCAD.Action.new(
      OpenSCAD.Intersection.new(),
      children
    )
  end

  @doc """
  Displays the
  [convex hull](https://doc.cgal.org/latest/Convex_hull_2/index.html)
  of child nodes.

  See [OpenSCAD hull](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#hull)
  """
  def hull(children) do
    OpenSCAD.Action.new(
      OpenSCAD.Hull.new(),
      children
    )
  end

  @doc """
  Displays the
  [minkowski sum](https://doc.cgal.org/latest/Minkowski_sum_3/index.html)
  of child nodes.

  See [OpenSCAD minkowski](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#minkowski)
  """
  def minkowski(children) do
    OpenSCAD.Action.new(
      OpenSCAD.Minkowski.new(),
      children
    )
  end

  def linear_extrude(children, params \\ []) do
    OpenSCAD.Action.new(
      OpenSCAD.LinearExtrude.new(params),
      children)
  end
end

