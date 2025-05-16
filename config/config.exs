import Config

config :article_management, ArticleManagement.Repo,
  username: "asuser",
  password: "as",
  database: "asuser",
  hostname: "localhost",
  pool_size: 10

config :article_management, ecto_repos: [ArticleManagement.Repo]

