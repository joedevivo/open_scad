defmodule OpenSCAD.Transformation do
  @moduledoc """
  Transformations are only different from Objects in that they can contain child
  Actions, and this module defines the generic functionallity for traversing the
  children on render.
  """

  alias OpenSCAD.Action

  defmacro __using__(_opts) do
    quote do
      use OpenSCAD.Action, has_children: true

      defimpl OpenSCAD.Renderable do
        def to_scad(me, opts), do: OpenSCAD.Transformation.to_scad(me, opts)
        def type(_me), do: :transformation
      end
    end
  end

  def to_scad(transformation, opts) do
    fname = Action.scad_name(transformation)
    params = Action.scad_params(transformation)

    child_opts = Keyword.update!(opts, :indent, &(&1 + 2))

    [
      OpenSCAD.Renderable.to_scad("#{fname}(#{params}){", opts),
      cond do
        is_list(transformation.children) ->
          transformation.children

        is_nil(transformation.children) ->
          []

        true ->
          [transformation.children]
      end
      |> Enum.map(&OpenSCAD.Renderable.to_scad(&1, child_opts)),
      OpenSCAD.Renderable.to_scad("}", opts)
    ]
    |> List.flatten()
    |> Enum.join("\n")
  end
end
