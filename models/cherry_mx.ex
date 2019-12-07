defmodule CherryMX do
  use OpenSCAD

  # Parameters
  @cherry_mx %{
    height: 14.4,
    width: 14.4,
    thickness: 4,
    margin: 3
  }

  # This one is the dactyl codebase way
  defp single_plate(:cherry) do
    top =
      cube(
        size: [@cherry_mx.width + 3, 1.5, @cherry_mx.thickness],
        center: true
      )
      |> translate(v: [0, 1.5 / 2 + @cherry_mx.height / 2, @cherry_mx.thickness / 2])

    side =
      cube(
        size: [1.5, @cherry_mx.height + 3, @cherry_mx.thickness],
        center: true
      )
      |> translate(v: [1.5 / 2 + @cherry_mx.width / 2, 0, @cherry_mx.thickness / 2])

    side_nub =
      hull([
        cylinder(h: 1, d: 2.75, center: true, _fn: 30)
        |> rotate(a: 90, v: [1, 0, 0])
        |> translate(v: [@cherry_mx.width / 2, 0, 1]),
        cube(size: [1.5, 2.75, @cherry_mx.thickness], center: true)
        |> translate(v: [1.5 / 2 + @cherry_mx.width / 2, 0, @cherry_mx.thickness / 2])
      ])

    half = union([top, side, side_nub])

    union([
      mirror(half, v: [1, 0, 0]),
      mirror(half, v: [0, 1, 0])
    ])
  end

  # TODO: has to be in a function
  def main() do
    write(single_plate(:cherry), "models/cherry_mx.scad")
  end
end
