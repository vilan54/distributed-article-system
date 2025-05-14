defmodule ArticleManagement.MixProject do
  use Mix.Project

  def project do
    [
      app: :article_management,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ArticleManagement.Application, []},  # Aquí es donde se asegura que tu módulo Application se inicie
      extra_applications: [:logger, :ecto, :ecto_sql, :postgrex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto_sql, "~> 3.7"},
      {:postgrex, "~> 0.15"},
      {:bcrypt_elixir, "~> 2.0"}
    ]
  end
end
