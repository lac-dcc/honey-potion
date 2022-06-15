defmodule Honey.MixProject do
  use Mix.Project

  @source_url "https://github.com/lac-dcc/honey-potion"
  @version "0.1.0"

  def project do
    [
      app: :honey,
      name: "Honey Potion",
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def package do
    [
      description: "Writing eBPF with Elixir!",
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Compilers Laboratory - Federal University of Minas Gerais (UFMG), Brazil"],
      licenses: ["GPL-3.0-only"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "https://hexdocs.pm/honey/changelog.html"
      }
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"],
      ],
      main: "readme",
      homepage_url: @source_url,
      source_url: @source_url,
      source_ref: @version,
      logo: "assets/honey.png",
      assets: "assets",
      formatters: ["html"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
