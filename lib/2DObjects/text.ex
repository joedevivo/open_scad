defmodule OpenSCAD.Text do
  @behaviour OpenSCAD.Element
  @type t :: %OpenSCAD.Text{}

  defstruct text: "", ## The text to generate.
            size: nil, ## The generated text will have approximately an ascent of the given value (height above the baseline). Default is 10.
                      ## Note that specific fonts will vary somewhat and may not fill the size specified exactly, usually slightly smaller. 
            font: nil, ## The name of the font that should be used. This is not the name of the font file, but the logical font name (internally handled by the fontconfig library). This can also include a style parameter, see below. A list of installed fonts & styles can be obtained using the font list dialog (Help -> Font List).
            halign: nil, ## String. The horizontal alignment for the text. Possible values are "left", "center" and "right". Default is "left".
            valign: nil, ## String. The vertical alignment for the text. Possible values are "top", "center", "baseline" and "bottom". Default is "baseline".
            spacing: nil, ## Decimal. Factor to increase/decrease the character spacing. The default value of 1 will result in the normal spacing for the font, giving a value greater than 1 will cause the letters to be spaced further apart.
            direction: nil, ## String. Direction of the text flow. Possible values are "ltr" (left-to-right), "rtl" (right-to-left), "ttb" (top-to-bottom) and "btt" (bottom-to-top). Default is "ltr".
            language: nil, ## String. The language of the text. Default is "en".
            script: nil, ## String. The script of the text. Default is "latin".
            '$fn': nil ## used for subdividing the curved path segments provided by freetype
  
  def new(params \\ []) do
    OpenSCAD.Element.new(
      %OpenSCAD.Text{},
      params)
  end
end

defimpl OpenSCAD.Object, for: OpenSCAD.Text do
  def to_scad(t) do
    :io_lib.format("text(\"~s\"~s~s~s~s~s~s~s~s);", 
                   [t.text,
                    OpenSCAD.Element.maybe_format(t, :font, &inspect/1),
                    OpenSCAD.Element.maybe_format(t, :halign, &inspect/1),
                    OpenSCAD.Element.maybe_format(t, :valign, &inspect/1),
                    OpenSCAD.Element.maybe_format(t, :spacing, &to_string/1),
                    OpenSCAD.Element.maybe_format(t, :direction, &inspect/1),
                    OpenSCAD.Element.maybe_format(t, :language, &inspect/1),
                    OpenSCAD.Element.maybe_format(t, :script, &inspect/1),
                    OpenSCAD.Element.maybe_format(t, :'$fn', &to_string/1)
                    ]) 
    |> to_string
  end 
end