# OpenSCAD

Interactive Elixir based CAD Modeling with OpenSCAD

[OpenSCAD](http://www.openscad.org) provides a programatic interface for
generating CAD models which can ultimately be 3D printed. While it's syntax
makes sense for rendering, it leaves something to be desired when it comes to
automating large sets of objects. The language also reads, in my opinion,
backwards. I found Elixir's pipe operator to be an elegant way to express these
models.

```elixir
## Draw a 3mm cube, with it's bottom left corner at 0,0,0
cube(size: 3) 
## rotate it 90 degrees around the x axis
|> rotate(v: {90, 0, 0}) 
## move it 10 mm along the y axis (depth)
|> translate(v: {0, 10, 0}) 

# a 1x2x3mm cube, with its center at 0,0,0
cube(size: {1, 2, 3}, center: true) 
```

## Features

* Models defined in Elixir
* Reusable components can be included as mix dependencies
* `iex -S mix` will watch for changes in a project's `./models` directory, and
  run those scripts.
* an escript can also be built that watches for changes in the directory
  specified by the command line, but that version won't import modules from a
  project's `./lib` dir.


## OpenSCAD Documentation

[Documentation](http://www.openscad.org/documentation.html)

[CheatSheet](http://www.openscad.org/cheatsheet/index.html)

## Installation

### OpenSCAD

You'll need OpenSCAD.

```shell
brew cask install openscad
```

Or download it for your platform [here](http://www.openscad.org/downloads.html)

### Adding to your project

Add to your project by putting the following in `mix.exs`:

```elixir
  def application do
    [extra_applications: [:logger, :open_scad]]
  end
  def deps do
    [{:open_scad, "~> 0.5.0"}]
  end
```

This includes the OpenSCAD language and a watcher for filesystem changes.

### Creating Models

In your projects' `./models` directory, create exs scripts. They can output any
number of `.scad` files.

Your `./lib` directory, you can define modules that represent complex, reusable
objects. These are things that you might want to include in other project, which
you can do by including your project as a dependency in that projects' mix file.

### Examples

My [Keyboards](https://github.com/joedevivo/keyboards) repo is built with this
library, and is a full working example.
