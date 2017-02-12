defmodule OpenSCAD.Element do
  @type object :: OpenSCAD.Circle.t
                | OpenSCAD.Cube.t
                | OpenSCAD.Cylinder.t
                | OpenSCAD.Polygon.t
                | OpenSCAD.Polyhedron.t
                | OpenSCAD.Sphere.t
                | OpenSCAD.Square.t 
                | OpenSCAD.Text.t

  @type action :: object | BitString

  @type operator :: OpenSCAD.Translate.t

  @type t :: action | operator

  @callback new(Keyword.t) :: OpenSCAD.Element.t
  
  @spec new(t, Keyword.t, Keyword.t((t, any -> t)))
        :: t
  def new(element, params, transformations \\ []) do
    List.foldl(transformations,
               {params, element},
               &maybe_override/2)
    |> from_params
  end
  
  ## Meant for piping transformation functions before the generic 
  ## operation `from_params/2`
  defp maybe_override({override_key, override_function}, {params, element}) do
    if Keyword.has_key? params, override_key do
      val = Keyword.get(params, override_key)
      {Keyword.delete(params, override_key), 
       override_function.(element, val)}
    else 
      {params, element}
    end 
  end

  ## Wrapper for good |>'ing
  defp from_params({params, element}) do
    List.foldl params,
               element,
               fn({k,v}, e) ->
                 Map.put e, k, v
               end
  end

  @spec maybe_format(t, atom, (any -> bitstring)) :: bitstring
  def maybe_format(element, key, f) do
    case Map.get(element, key) do
      nil -> ""
      value ->
        :io_lib.format(", ~s = ~s", 
                       [to_string(key), f.(value)]) 
    end   
  end
end