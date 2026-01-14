defmodule Honey.MixProject do
  use Mix.Project

  @source_url "https://github.com/lac-dcc/honey-potion"
  @version "0.2.0"

  def project do
    [
      app: :honey,
      name: "Honey Potion",
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      docs: docs(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Honey Potion is a compiler that translates a subset of Elixir into eBPF programs."
  end

  def package do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      maintainers: [
        "Compilers Laboratory - Federal University of Minas Gerais (UFMG), Brazil",
        "Adriano Santos - <solid.sistemas@gmail.com>"
      ],
      licenses: ["GPL-3.0-only"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "https://hexdocs.pm/honey/changelog.html"
      }
    ]
  end

  defp docs do
    [
      main: "Honey",
      homepage_url: @source_url,
      source_url: @source_url,
      source_ref: @version,
      logo: "assets/honey.png",
      assets: "assets",
      formatters: ["html"],
      extras: [
        "docs/guides/getting_started/quickstart.md",
        "docs/guides/getting_started/language.md",
        "docs/guides/advanced/concepts/honey.md",
        "docs/guides/advanced/concepts/makefile.md"
      ],
      groups_for_modules: [
        API: [
          Honey
        ],
        AST: [
          Honey.AST.RecursionExpansion
        ],
        Analysis: [
          Honey.Analysis.AstSize,
          Honey.Analysis.ElixirTypes,
          Honey.Analysis.StaticAnalysis
        ],
        Codegen: [
          Honey.Codegen.Boilerplates,
          Honey.BpfHelpers
        ],
        Compiler: [
          Honey.Compiler.CodeGenerator,
          Honey.Compiler.Translator,
          Honey.Compiler.Pipeline
        ],
        Optimizations: [
          Honey.Optimization.Optimizer,
          Honey.Optimization.ConstantPropagation,
          Honey.Optimization.DeadCodeElimination,
          Honey.Optimization.TypePropagation
        ],
        Runtime: [
          Honey.Runtime.Info,
          Honey.Runtime.TranslatedCode
        ],
        Types: [
          Honey.TypeSet
        ],
        Utils: [
          Honey.Utils.Core,
          Honey.Utils.Directories,
          Honey.Utils.Guard,
          Honey.Utils.Write
        ]
      ],
      groups_for_extras: [
        "Getting Started": ~r"^docs/guides/getting_started/",
        Advanced: ~r"^docs/guides/advanced/"
      ]
    ]
  end

  defp aliases do
    [
      # The Honey.Mix.Tasks.CompileBPF.run function currently has no use. It has been left as a reference of
      # where code can be added for it to be executed before the compilation step of Elixir.
      # compile: ["compile", &Honey.Mix.Tasks.CompileBPF.run/1]
    ]
  end
end
