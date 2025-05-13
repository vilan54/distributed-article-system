#Gestion de articulos y todas sus funciones
defmodule ArticleManagement.ArticleManager do
  @moduledoc"""
Módulo central para la gestión de artículos.
"""

  alias ArticleManagement.{Repo, Content.Article}

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
