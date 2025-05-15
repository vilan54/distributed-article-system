import Config

config :article_management, ArticleManagement.Repo,
  username: "asuser",
  password: "as",
  database: "asuser",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
