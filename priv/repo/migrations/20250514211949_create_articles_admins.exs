defmodule ArticleManagement.Repo.Migrations.CreateArticlesAdmins do
  use Ecto.Migration

  def change do
    create table(:articles_admins) do
      add :article_id, references(:articles, on_delete: :nothing)  # Relación con la tabla de artículos
      add :admin_id, references(:users, on_delete: :nothing)       # Relación con la tabla de usuarios (administradores)
      add :assigned_at, :utc_datetime, null: false                  # Fecha y hora en que se asignó el artículo

      timestamps()
    end

    # Asegurarse de que no haya duplicados entre los pares artículo-admin
    create unique_index(:articles_admins, [:article_id, :admin_id])
  end
end
