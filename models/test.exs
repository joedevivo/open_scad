defmodule TestModel do
  use OpenSCAD.Model

  x = 4
  myCube = cube(size: x)
  
  myCube
  |> to_scad
  |> IO.puts

  cube(size: 4)
  |> translate(x: 1, y: 2, z: 3)
  |> to_scad
  |> IO.puts

  cubes = [
    cube(size: 1),
    cube(size: 2)
  ]
  |> translate(x: 3, y: 9, z: 100)
  |> rotate(x: 90)

  cubes
  |> to_scad
  |> IO.puts

  union([myCube, cubes])
  |> to_scad
  |> IO.puts

end

defmodule TestModel2 do
  use OpenSCAD.Model
  x = 4
  myCube = cube(size: x)
  
  myCube
  |> to_scad
  |> IO.puts

end

defmodule NotAModel do
  

end