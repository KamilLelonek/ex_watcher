defmodule ExWatcher.Mixfile do
  use Mix.Project

  def project() do
    [
      app:            :ex_watcher,
      version:         "0.1.0",
      elixir:          "~> 1.3",
      build_embedded:  Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps:            deps(),
      description:     description(),
      package:         package(),
    ]
  end

  def application() do
    [
      applications: apps(),
      mod:          {ExWatcher, []}
    ]
  end

  defp apps() do
    [
      :logger,
    ]
  end

  defp deps() do
    [
      {:fs, "~> 0.9"},
      {:ex_doc, ">= 0.0.0"},
    ]
  end

  defp description() do
    """
      An Elixir file change watcher
    """
  end

  defp package() do
    [
      name:        :ex_watcher,
      files:       ["lib", "config", "mix.exs", "README.md"],
      maintainers: ["Kamil Lelonek"],
      licenses:    ["MIT"],
      links:       %{ "GitHub" => "https://github.com/KamilLelonek/ex_watcher" },
    ]
  end
end
