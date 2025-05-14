defmodule ArticleManagement.Repo.Migrations.CreateArticlesTags do
  use Ecto.Migration

  def change do
    create table(:article_tags) do
      add :article_id, references(:articles), null: false
      add :tag_id, references(:tags), null: false

      timestamps()
    end

    create unique_index(:article_tags, [:article_id, :tag_id])
  end
end
