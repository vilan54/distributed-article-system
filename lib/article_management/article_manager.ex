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
  Listar artículos que no están en estado `pending_review`
  """
  def list_articles do
    status = :pending_review

    from(a in Article, where: a.status != ^status)
    |> Repo.all()
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

      attrs = Map.put(attrs, :status, :pending_review)

      %Article{}
      |> Article.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:ok, article} ->
          ModerationQueue.enqueue(article.id)
          {:ok, article}

        {:error, reason} ->
          {:error, reason}
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
    case Repo.get(ArticleManagement.Identity.User, author_id) do
      nil -> {:error, :author_not_found}
      user -> {:ok,user}
    end
  end

  defp check_permissions(%{role: role}) when role in [:user, :admin], do: :ok
  defp check_permissions(_), do: {:error, :unauthorized}

end
