defmodule OpenSCAD.MixProject do
  use Mix.Project

  def project do
    [
      app: :open_scad,
      version: "0.5.2",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      escript: escript(),
      build_embedded: true,
      package: package(),
      name: "OpenSCAD",
      description: description(),
      source_url: "https://github.com/joedevivo/open_scad"
    ]
  end

  def application do
    [
      mod: {OpenSCAD.Application, []},
      applications: [:mix],
      included_applications: [:file_system],
      extra_applications: [:logger, :file_system]
    ]
  end

  defp deps do
    [
      {:file_system, "~> 0.2.7"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:dialyzex, "~> 1.2.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "pages/getting_started.md",
        "pages/open_scad_language.md",
        "pages/slicing.md"
      ]
    ]
  end

  defp escript do
    [
      main_module: OpenSCAD.CLI,
      strip_beam: true,
      embed_elixir: true,
      app: nil,
      path: "./_build/escript/open_scad"
    ]
  end

  defp description do
    """
    An Elixir Library for working with OpenSCAD models.
    """
  end

  defp package do
    [
      name: "open_scad",
      maintainers: ["Joe DeVivo"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joedevivo/open_scad"}
    ]
  end
end
