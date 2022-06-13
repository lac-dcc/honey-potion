defmodule Honey.MixProject do
  use Mix.Project

  def project do
    [
      app: :honey,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Honey Potion",
      source_url: "https://github.com/lac-dcc/honey-potion",
      homepage_url: "https://github.com/lac-dcc/honey-potion",
      docs: [
        main: "readme",
        logo: "assets/honey.png",
        extras: ["README.md": [title: "Documentation"]],
        assets: "assets",
        api_reference: false,
        filter_modules: ~r/$^/
      ]
    ]
  end

  def description do
    """
    Writing eBPF with Elixir!
    """
  end

  def package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Compilers Laboratory - Federal University of Minas Gerais (UFMG), Brazil"],
      licenses: ["GPL-3.0-only"],
      links: %{
        "GitHub" => "https://github.com/lac-dcc/honey-potion",
        "Docs" => ""
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
