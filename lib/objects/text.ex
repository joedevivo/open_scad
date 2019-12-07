defmodule OpenSCAD.Text do
  use OpenSCAD.Object

  @type t :: %{
          text: String.t(),
          size: float(),
          # font="Liberation Sans:style=Bold Italic"
          # Only includes Liberation Mono, Liberation Sans, Liberation Sans Narrow and Liberation Serif
          # by default, but any system font can be used.
          # No need for importing other fonts via: `use <ttf/paratype-serif/PTF55F.ttf>`
          font: String.t(),
          halign: :left | :center | :right,
          valign: :top | :center | :baseline | :bottom,
          spacing: float(),
          direction: :ltr | :rtl | :ttb | :btt,
          language: String.t(),
          script: String.t(),
          _fn: integer()
        }
end
