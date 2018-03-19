defmodule OpenSCAD.Model do

  def write(obj, path) do
    File.write(path, OpenSCAD.to_scad(obj))
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      import OpenSCAD
      import OpenSCAD.Model, only: [write: 2]
      #@before_compile unquote(__MODULE__)

      def is_open_scad_model? do
        true
      end
    end
  end

  #defmacro __before_compile__(_env) do
  #  quote do
  #    def run do
  #      ## Not sure this is needed, meant for post processing file IO, but maybe that's a manual thing.
  #      IO.puts "TODO: File IO #{__MODULE__}"
  #    end
  #  end
  #end

end
