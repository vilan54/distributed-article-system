defmodule ArticleManagement.Content.Article do
 use Ecto.Schema
 import Ecto.ChangeSet

 @moduledoc """
Esquema que representa un artículo del sistema
"""
 schema "articles" do
   field :title, :string
   field :content, :string
   field :status, Ecto.Enum, values: [:draft, :pending_review, :published, :rejected]
   field :author_id, :id

   timestamps()
 end

 def changeset(article, attrs) do
   article
   |> cast(attrs, [:title, :content, :status, :author_id])
   |> validate_required([:title, :content, :status, :author_id])
 end
 end