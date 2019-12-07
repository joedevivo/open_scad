# OpenSCAD Language Reference

This implementation is fairly straight forward, and parallels the functions in
the OpenSCAD documentation.

The biggest difference is that fields that start with a `$` need to start with a
`_` instead, because if we wanted to keep the `$` in Elixir, we'd have to write
the keys like this: `:'$fn'` and that's 3 extra characters that have the added
benefit of making the code uglier. I stand by my choice.


## Example : Cube

Cube in OpenSCAD has two attributes, `size` and `center`.

* `size` can be an integer or a list of 3 integers (x,y,z).
* `center` is a boolean, true putting the cube's center at 0,0,0, false putting
  the lower left corner at 0,0,0

Here's some examples

```openscad
cube(size = 2, center = false);
cube(size = [1,2,3], center = true);
```

The Elixir calls massage the syntax only a little

```elixir
cube(size: 2, center: false)
cube(size: [1,2,3], center: true)
```

If you really want to, you can use a Tuple instead of a list there. It'll render
the same in OpenSCAD.

## OpenSCAD Documentation

[Documentation](http://www.openscad.org/documentation.html)

[CheatSheet](http://www.openscad.org/cheatsheet/index.html)
