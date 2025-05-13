defmodule ArticleManagement.Content.Article do
 use Ecto.Schema
 import Ecto.Changeset

 @moduledoc """
 Esquema que representa un artículo del sistema
 """
 schema "articles" do
   field :title, :string
   field :content, :string
   field :status, Ecto.Enum, values: [:draft, :pending_review, :published, :rejected]
   belongs_to :author, ArticleManagement.Accounts.User

   timestamps()
 end

 def changeset(article, attrs) do
  article
  |> cast(attrs, [:title, :content, :status, :author_id])
  |> validate_required([:title, :content, :status, :author_id])
 end

end
