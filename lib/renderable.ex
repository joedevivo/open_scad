defprotocol OpenSCAD.Renderable do
  @moduledoc """
  We'll try and render anything, because it could be a deeply nested structure
  of things to render, so we'll keep going until we hit something we can't
  handle.
  """

  @typedoc """
  The types of renderables
  """
  @type types ::
          :string
          | :list
          | :object
          | :transformation
          | :nope

  @typedoc """
  Rendering Options:
    * indent: nil | integer()
      - number of spaces to prefix this renderable with
      - nil skips indenting all together
    * raise: boolean()
      - true (default) - raises if any child is unrenderable
      - false - skips the child entirely, renders what it can
  """
  @type options ::
          {:indent, nil | non_neg_integer()}
          | {:raise, boolean()}
  @fallback_to_any true

  # alias OpenSCAD.Renderable.Options

  @doc """
  Returns the type of the renderable, the important ones being :object and
  :transformation, which will be used to generate different functionallity via
  the OpenSCAD.Action.__before_compile__ macro
  """
  @spec type(any()) :: types()
  def type(thing)

  @doc """
  Returns a string of what is hopefully valid OpenSCAD, but it's possible the
  programmer is asking for something invalid, like a circle with an 'eleventeen'
  radius. It'll try and pass that along to OpenSCAD, and it would fail just as
  OpenSCAD should.

  Will raise if something isn't renderable within the structure.
  """
  @spec to_scad(any(), [options()]) :: String.t()
  def to_scad(thing, opts \\ [indent: 0, raise: true])
end

defimpl OpenSCAD.Renderable, for: BitString do
  @moduledoc """
  Rendering strings is as easy as indenting them. It's meant to be an explicit
  bypass for things you want to express in OpenSCAD that are not yet covered by
  this project.
  """
  def type(_), do: :string
  def to_scad(me, opts), do: "#{String.pad_leading("", opts[:indent])}#{me}"
end

defimpl OpenSCAD.Renderable, for: List do
  def to_scad(me, opts) do
    me
    |> Enum.map(&OpenSCAD.Renderable.to_scad(&1, opts))
    |> Enum.join("\n")
  end

  def type(_me), do: :list
end

defimpl OpenSCAD.Renderable, for: Any do
  require Logger
  def type(_), do: :nope

  # Ignore this dialyzer warning, it doesn't like always raising, but this is a
  # catch all, it's fine
  def to_scad(me, opts) do
    if opts[:raise] do
      raise "#{inspect(me)} is not renderable"
      :error
    else
      _ = Logger.warn("#{inspect(me)} is not renderable")
      ""
    end
  end
end
