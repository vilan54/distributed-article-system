defmodule ArticleManagement.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :content, :text, null: false
      add :status, :string, null: false, default: "draft"
      add :author_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:articles, [:author_id])
  end
end
