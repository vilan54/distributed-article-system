defmodule ArticleManagement.Identity.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    many_to_many :articles, ArticleManagement.Identity.Article, join_through: "article_tags"

    timestamps()
  end
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end