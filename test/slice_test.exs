defmodule OpenSCAD.SliceTest do
  defmodule Model do
    use OpenSCAD

    def main(name) do
      [
        cube(size: [100, 100, 100], center: true),
        cylinder(r1: 0, r2: 45, h: 50, _fn: 100)
      ]
      |> difference()
      |> slice(layer: 5, height: 50, name: name)
    end
  end

  use ExUnit.Case

  test "slice test" do
    test_dir = "_build/test/output/slice"
    File.rm_rf!(test_dir)
    File.mkdir_p!(test_dir)
    OpenSCAD.SliceTest.Model.main(test_dir)

    file_prefixes = Enum.map(0..10, &String.pad_leading("#{&1}", 2, ["0"]))

    file_prefixes
    |> Enum.each(fn x ->
      path = Path.join(test_dir, x)
      scad = "#{path}.scad"
      assert File.exists?(scad)
      svg = "#{path}.svg"
      assert File.exists?(svg)
    end)
  end
end
