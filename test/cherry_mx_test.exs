defmodule OpenSCAD.CherryMXTest do
  use ExUnit.Case

  test "watch & render" do
    infile = "models/cherry_mx.ex"
    outfile = "models/cherry_mx.scad"

    File.touch!(infile)
    File.rm(outfile)
    File.touch!(outfile)

    infileinfo = File.lstat!(infile)
    outfileinfo = File.lstat!(outfile)

    assert outfileinfo.size == 0
    # Guarantees different timestamps on files
    Process.sleep(1_000)
    File.touch!(infile)

    # Give it a second to render
    Process.sleep(1_000)

    infileinfo2 = File.lstat!(infile)
    outfileinfo2 = File.lstat!(outfile)

    assert NaiveDateTime.from_erl!(outfileinfo2.mtime) >
             NaiveDateTime.from_erl!(outfileinfo.mtime)

    assert NaiveDateTime.from_erl!(infileinfo2.mtime) > NaiveDateTime.from_erl!(infileinfo.mtime)

    assert File.read!(outfile) === """
           union(){
             mirror(v = [1, 0, 0]){
               union(){
                 translate(v = [0, 7.95, 2.0]){
                   cube(center = true, size = [17.4, 1.5, 4]);
                 }
                 translate(v = [7.95, 0, 2.0]){
                   cube(center = true, size = [1.5, 17.4, 4]);
                 }
                 hull(){
                   translate(v = [7.2, 0, 1]){
                     rotate(a = 90, v = [1, 0, 0]){
                       cylinder($fn = 30, center = true, d = 2.75, h = 1);
                     }
                   }
                   translate(v = [7.95, 0, 2.0]){
                     cube(center = true, size = [1.5, 2.75, 4]);
                   }
                 }
               }
             }
             mirror(v = [0, 1, 0]){
               union(){
                 translate(v = [0, 7.95, 2.0]){
                   cube(center = true, size = [17.4, 1.5, 4]);
                 }
                 translate(v = [7.95, 0, 2.0]){
                   cube(center = true, size = [1.5, 17.4, 4]);
                 }
                 hull(){
                   translate(v = [7.2, 0, 1]){
                     rotate(a = 90, v = [1, 0, 0]){
                       cylinder($fn = 30, center = true, d = 2.75, h = 1);
                     }
                   }
                   translate(v = [7.95, 0, 2.0]){
                     cube(center = true, size = [1.5, 2.75, 4]);
                   }
                 }
               }
             }
           }
           """
  end
end
