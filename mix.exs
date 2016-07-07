defmodule Pushex.Mixfile do
  use Mix.Project

  def project do
    [app: :pushex,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript,
     deps: deps()]
  end

  def escript do
    [main_module: Pushex]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :conform, :conform_exrm, :exredis, :exrm, :logger, :pigeon, :poison
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:exredis, "~> 0.2"},
      {:pigeon, "~> 0.8"},
      {:poison, "~> 2.0"},
      {:logger_file_backend, "~> 0.0.8"},
      {:chatterbox, github: "joedevivo/chatterbox", override: true},
      {:conform, "~> 2.0"},
      {:conform_exrm, "~> 1.0"},
      {:exrm, "~> 1.0"}
    ]
  end
end
