# Slicing

`slice/2` is for taking a model you've generated and turning it into a series of
SVGs that can be fabricated in 2D with a Laser cutter, CNC, or even a Cricut.

Take the following model:

```elixir
[
  cube(size: [100, 100, 100], center: true),
  cylinder(r1: 0, r2: 45, h: 50, _fn: 100)
]
|> difference()
```

which will output the following object

![OpenSCAD Render](assets/slice_1.png "OpenSCAD Render")

Now, if we want to slice it into 11 layers, we can give it a layer height of 5,
and a height of 50, since that's as high above the z-axis as the model reaches.

```elixir
|> slice(layer: 5, height: 50, name: "output_dir")
```

This will create `output_dir`, and inside it will output the following files:

* model.scad - the entire model
* 00-10.scad - the scad of each layer
* 00-10.svg - the svg for each layer

Here's `05.svg` for reference:

<center>
<img src="assets/05.svg" alt="05.svg, circle gets the square!" /><br/>
"05.svg, circle gets the square!"
</center>
<br/>

At this point you can do with your svgs whatever you want. I wanted to bring
this object back into the physical world...

![Cardboard](assets/slice_2.png "Cardboard")
![Cardboard](assets/slice_3.png "Cardboard")
![Cardboard](assets/slice_4.png "Cardboard")
