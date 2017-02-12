defmodule OpenSCAD.Action do
  defstruct children: [],
            element: nil,
            modifier: nil
  @type t :: %OpenSCAD.Action{
    children: [t],
    element:  nil | OpenSCAD.Element.t,
    modifier: nil | bitstring
  }

  def new(element, children \\ [])
  def new(element, var) when is_bitstring(var) do
    new(element, [var])
  end
  def new(element, children) when is_list(children) do
    %OpenSCAD.Action{
      children: children,
      element: element
    }
  end
  def new(element, child) do
    new(element,[child])
  end

  def modify(action, modifier) do
    if Enum.member?(["*", "!", "#", "%"], modifier) do
      %OpenSCAD.Action{ action | modifier: modifier}
    else 
      action
    end
  end

  defp maybe_modifier(%OpenSCAD.Action{element: nil}) do
    ""    
  end
  defp maybe_modifier(%OpenSCAD.Action{modifier: nil}) do
    ""    
  end
  defp maybe_modifier(action) do
    action.modifier  
  end

  defp maybe_element(nil) do
    ""
  end
  defp maybe_element(element) do
    OpenSCAD.Object.to_scad(element)
  end
  
  defp maybe_children(%OpenSCAD.Action{children: c}, _) when length(c) == 0 do
    "\n"
  end 
  defp maybe_children(%OpenSCAD.Action{children: c}, indent) when length(c) == 1 do
    "\n" <> to_scad(hd(c), indent)
  end
  defp maybe_children(%OpenSCAD.Action{element: nil, children: c}, 0) do
    Enum.join((for child <- c, do: to_scad(child)),"")
  end
  defp maybe_children(%OpenSCAD.Action{children: c}, indent) do
    " {\n"
    <>
    Enum.join((for child <- c, do: to_scad(child, indent+2)),"")
    <>
    String.pad_leading("", indent) <> "}\n"
  end

  @spec to_scad(t | [t], non_neg_integer) :: bitstring()
  def to_scad(action, indent \\ 0)
  def to_scad(action, indent) when is_bitstring(action) do
    to_scad(OpenSCAD.Action.new(action), indent)
  end
  def to_scad(actions, indent) when is_list(actions) do
    to_scad(OpenSCAD.Action.new(nil, actions), indent)
  end
  def to_scad(action, indent) do
    ## Indentation, for readable .scad files
    String.pad_leading("", indent)
    <>
    maybe_modifier(action)
    <>
    maybe_element(action.element)
    <> 
    maybe_children(action, indent)

#    cond do
#      is_list(action.children) ->
#        (for obj <- action, do: OpenSCAD.Action.to_scad(obj, indent))
#        |> Enum.join("")
#      (OpenSCAD.Object.impl_for action) != nil ->
#        String.pad_leading("", indent)
#        <>
#        OpenSCAD.Object.to_scad(action)
#        <> "\n"
#        |> to_string 
#      (OpenSCAD.Operator.impl_for action) != nil ->
#        String.pad_leading("", indent)
#        <>
#        OpenSCAD.Operator.to_scad(action)
#        <>
#        if is_list(OpenSCAD.Operator.children(action)) do
#          " {\n"
#          <>
#          OpenSCAD.Action.to_scad(OpenSCAD.Operator.children(action), indent+2)
#          <>
#          String.pad_leading("", indent)
#          <>
#          "}\n"
#        else
#          "\n"
#          <>
#          OpenSCAD.Action.to_scad(OpenSCAD.Operator.children(action), indent)
#        end
#    end
  end
  
end

defprotocol OpenSCAD.Object do
  def to_scad(object)
end

defprotocol OpenSCAD.Modifier do
  def to_scad(modifier)
end

#defprotocol OpenSCAD.Operator do
#  def to_scad(operator)
#  def children(operator)
#end

