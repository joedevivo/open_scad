# Welcome to OpenSCAD

Hi. Do you want to make a physical object from Elixir code? Then you're in the
right place!

## Dependencies

You're going to need [OpenSCAD](http://www.openscad.org). You can get it from
your favorite package manager, or direct download.

## Project Setup

Create your own brand new Elixir project for your design. It's up to you how
many models you'd like in a project.

Include this library in your deps.

```
{:open_scad, "~> 0.5.0"}
```

Create a top level directory `models`, for your models. `lib` can be used for
established components, that can be used in your models, and it's probably best
to actively develop the component in `models`, but once you're satisfied with
it, it can be moved to `lib` to save on recompile time.

Any `.ex` file in `models` will be watched for changes once you run `iex -S
mix`, and it will be run on every save. Your model should have a main/0 which
will write at least one file. That file is your `.scad` render.

Since OpenSCAD also actively watches for changes, once you open up this file in OpenSCAD, and your `iex -S mix` is running, every time you save the model, it will generate the `.scad` which will update in OpenSCAD!

TL;DR - Save elixir, see object 

### Model Template

```elixir
defmodule MyModel do
  use OpenSCAD

  def main() do
    cube(size: 3)
    |> rotate(a: 45, v: [1,1,1])
    |> write("cube.scad")
  end
end
```