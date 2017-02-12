defmodule OpenSCAD.Mixfile do
  use Mix.Project

  def project do
    [
      app: :open_scad,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      name: "OpenSCAD",
      description: description(),
      source_url: "https://github.com/joedevivo/open_scad",
    ]
  end

  def application do
    [
      mod: {OpenSCAD.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :file_system, "~> 0.2.1" },
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
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
