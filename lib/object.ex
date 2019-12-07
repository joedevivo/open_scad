defmodule OpenSCAD.Object do
  @moduledoc """
  Represents the common aspects of Objects, which are effectively the leaves of
  the tree.
  """
  alias OpenSCAD.Action

  defmacro __using__(_options) do
    quote do
      use OpenSCAD.Action

      defimpl OpenSCAD.Renderable do
        def type(_me), do: :object
        def to_scad(me, opts), do: OpenSCAD.Object.to_scad(me, opts)
      end
    end
  end

  def to_scad(object, opts) do
    fname = Action.scad_name(object)
    params = Action.scad_params(object)

    "#{fname}(#{params});"
    |> OpenSCAD.Renderable.to_scad(opts)
  end
end
