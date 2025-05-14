defmodule ArticleManagement.Identity.Rating do
  @moduledoc """
Esquema que representa una valoración dentro del sistema
"""
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :score, :integer
    belongs_to :user, ArticleManagement.Identity.User
    belongs_to :article, ArticleManagement.Identity.Article

    timestamps()
  end

  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:score, :user_id, :article_id])
    |> validate_required([:score, :user_id, :article_id])
    |> validate_number(:score, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> unique_constraint([:user_id, :article_id])
  end
end
