defmodule ArticleManagement.Repo do
  use Ecto.Repo,
    otp_app: :article_management,
    adapter: Ecto.Adapters.Postgres
end
