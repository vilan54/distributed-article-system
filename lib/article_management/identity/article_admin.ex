defmodule ArticleManagement.Identity.ArticleAdmin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles_admins" do
    belongs_to :article, ArticleManagement.Identity.Article
    belongs_to :admin, ArticleManagement.Identity.User
    field :assigned_at, :utc_datetime

    timestamps()
  end

  def changeset(article_admin, attrs) do
    article_admin
    |> cast(attrs, [:article_id, :admin_id, :assigned_at])
    |> validate_required([:article_id, :admin_id, :assigned_at])
  end
end
