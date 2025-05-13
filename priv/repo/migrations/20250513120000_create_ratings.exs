defmodule ArticleManagement.Repo.Migrations.CreateRatings do
use Ecto.Migration


def change do
  create table(:ratings) do
    add :score, :integer, null: false
    add :user_id, references(:users), null: false
    add :article_id, references(:articles), null: false

    timestamps()
  end

  create unique_index(:ratings, [:user_id, :article_id])
end
end