#Gestion de articulos y todas sus funciones
defmodule ArticleManagement.ArticleManager do
  @moduledoc"""
Módulo central para la gestión de artículos.
"""
  import Ecto.Query
  alias ArticleManagement.{Repo, Identity.Article}
  alias ArticleManagement.Identity.Rating
  alias ArticleManagement.ModerationQueue

  @doc """
  Listar artículos
  """
  def list_articles do
    Repo.all(Article)
  end

  @doc """
  Obtiene artículo por su ID
  """
  def get_article(id), do: Repo.get(Article, id)

  @doc """
  Crea un artículo en el sistema verificando tanto el autor como sus permisos.
  """
  def create_article(attrs) do
    author_id = attrs["author_id"] || attrs[:author_id]

    with {:ok, user} <- fetch_author(author_id),
         :ok <- check_permissions(user) do
      %Article{}
      |> Article.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:ok, article} ->
          # Cambiar el estado del artículo a :pending_review
          article
          |> Article.changeset(%{status: :pending_review})
          |> Repo.update()

          # Agregar el artículo a la cola de moderación
          ModerationQueue.enqueue(article.id)
          {:ok, article}

        {:error, reason} -> {:error, reason}
      end
    end
  end


  @doc """
  Actualizar artículo
  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Elimina un artículo del sistema
  """
  def delete_article(%Article{} = article), do: Repo.delete(article)

  @doc """
  Crea una valoración del artículo en el sistema
  """

  def rate_article(attrs) do
  changeset = Rating.changeset(%Rating{}, attrs)

   Repo.insert(changeset,
     on_conflict: :replace_all,
     conflict_target: [:user_id, :article_id]
   )
  end

  @doc """
  Se filtran los artículos por tags
  """


  def list_article_tag(article_id) do
    from(tag in ArticleManagement.Identity.Tag,
      join: article in assoc(tag, :article),
      where: article.id == ^article_id,
      select: tag
    )
    |> Repo.all()
  end


  defp fetch_author(nil), do: {:error, :author_id_required}

  defp fetch_author(author_id) do
    case Repo.get(ArticleManagement.Accounts.User, author_id) do
      nil -> {:error, :author_not_found}
      user -> {:ok,user}
    end
  end

  defp check_permissions(%{role: role}) when role in [:user, :admin], do: :ok
  defp check_permissions(_), do: {:error, :unauthorized}

end
