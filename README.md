# OpenSCAD

Interactive Elixir based CAD Modeling with OpenSCAD

[OpenSCAD](http://www.openscad.org) provides a programatic interface for
generating CAD models which can ultimately be 3D printed. While it's syntax
makes sense for rendering, it leaves something to be desired when it comes to
automating large sets of objects. The language also reads, in my opinion,
backwards. I found Elixir's pipe operator to be an elegant way to express these
models.

```elixir
cube(size: 3) ## Draw a 3mm cube, with it's bottom left corner at 0,0,0
|> rotate(x: 90) ## rotate it 90 degrees around the x axis
|> translate(y: 10) ## move it 10 mm along the y axis (depth)

```

## Features

* Models defined in Elixir
* Resuable components can be included as mix dependencies
* `iex -S mix` will watch for changes in a project's `./models` directory, and
  run those scripts.


## Installation

### OpenSCAD

You'll need OpenSCAD.

```shell
brew cask install openscad
```

Or just download it for your platform
[here](http://www.openscad.org/downloads.html)

### Adding to your project

Add to your project by putting the following in `mix.exs`:

```elixir
  def application do
    [extra_applications: [:logger, :open_scad]]
  end
  def deps do
    [{:open_scad, "~> 0.1.0"}]
  end
```

This includes the OpenSCAD language and a watcher for filesystem changes.


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/open_scad](https://hexdocs.pm/open_scad).

### Creating Models

In your projects' `./models` directory, create exs scripts. They can output any
number of `.scad` files.

Your `./lib` directory, you can define modules that represent complex, reusable
objects. These are things that you might want to include in other project, which
you can do by including your project as a dependency in that projects' mix file.

### Examples

My [Keyboards](https://github.com/joedevivo/keyboards) repo is built with this
library, and is a full working example.

## Language Implementation

The [OpenSCAD Language
Introduction](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Introduction)
describes three types of things:

* Object
  Anything that can be rendered, and always ends with a `;`.
* Action
  An Object *OR* a variable assignment.
* Operator
  Anything that changes an Object. Syntactically, they can operate on
  any action, but as far as I can tell, have no effect.

My intention with this library is to put the heavy lifting of functions,
variables and programming in general on Elixir, so there will be little
accounting for variable assignment, but it should be possible, in order for us
to set things like `$fs` in a global context. (see [Special
Variables](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#.24fa.2C_.24fs_and_.24fn)
for more.)
