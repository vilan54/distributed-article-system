defmodule ArticleManagement.ReviewPipeline do
  @moduledoc """
  Módulo para la gestión de la revisión de artículos.
  Este módulo se encarga de asignar artículos a administradores para su revisión,
  así como de aceptar o rechazar artículos según la decisión del administrador.
  """

  import Ecto.Query
  alias ArticleManagement.{Repo, Identity.Article, Identity.User, Identity.ArticleAdmin, ModerationQueue}

  @doc """
  Asigna un artículo a un administrador aleatorio de la cola de moderación.
  Si no hay artículos en la cola o si no se encuentra el artículo, se retorna un error.
  """
  def assign_article_to_admin do
    case ModerationQueue.dequeue() do
      nil -> {:error, :no_articles_in_queue}
      article_id ->
        case get_article(article_id) do
          {:ok, article} -> assign_to_random_admin(article)
          {:error, :article_not_found} -> {:error, :article_not_found}
        end
    end
  end

  @doc """
  Devuelve el artículo que ha sido asignado a un administrador específico.
  """
  def get_assigned_article(admin_id) do
    query =
      from aa in ArticleAdmin,
        where: aa.admin_id == ^admin_id,
        order_by: [asc: aa.assigned_at],
        limit: 1,
        preload: [:article]

    case Repo.one(query) do
      nil -> {:error, :no_assigned_articles}
      %ArticleAdmin{article: article} -> {:ok, article}
    end
  end

  # Función privada para obtener el artículo por ID
  defp get_article(article_id) do
    case Repo.get(Article, article_id) do
      nil -> {:error, :article_not_found}
      article -> {:ok, article}
    end
  end

  # Asignar un artículo a un administrador aleatorio y guardar en la tabla intermedia
  defp assign_to_random_admin(article) do
    admins = Repo.all(from u in User, where: u.role == :admin)

    if Enum.empty?(admins) do
      {:error, :no_admins_found}
    else
      admin = Enum.random(admins)

      changeset = ArticleAdmin.changeset(%ArticleAdmin{}, %{
        article_id: article.id,
        admin_id: admin.id,
        assigned_at: DateTime.utc_now()
      })

      case Repo.insert(changeset) do
        {:ok, _article_admin} ->
          IO.puts("Artículo #{article.title} asignado a #{admin.username}")
          {:ok, %{article: article, admin: admin}}

        {:error, reason} ->
          IO.puts("Error al asignar artículo: #{inspect(reason)}")
          {:error, :failed_to_assign_article}
      end
    end
  end

  # Función principal para aceptar o rechazar el artículo
  @doc """
  Revisa el artículo, aceptándolo o rechazándolo según la decisión del administrador.
  El artículo también será removido de la tabla `articles_admins` tras la revisión.
  """
  def review_article(admin_id, article_id, decision) do
    query =
      from aa in ArticleAdmin,
        where: aa.admin_id == ^admin_id and aa.article_id == ^article_id,
        preload: [:article, :admin]

    case Repo.one(query) do
      nil -> {:error, :not_assigned}
      %ArticleAdmin{article: article, admin: admin} -> process_review(article, admin, decision)
    end
  end

  # Función privada para procesar la decisión de aceptación o rechazo
  defp process_review(article, admin, decision) do
    case decision do
      :accept ->
        article
        |> Article.changeset(%{status: :published})
        |> Repo.update()

        Repo.delete_all(
          from aa in ArticleAdmin,
          where: aa.article_id == ^article.id and aa.admin_id == ^admin.id
        )

        IO.puts("Artículo #{article.title} aceptado por #{admin.username}")
        {:ok, article}

      :reject ->
        article
        |> Article.changeset(%{status: :rejected})
        |> Repo.update()

        Repo.delete_all(
          from aa in ArticleAdmin,
          where: aa.article_id == ^article.id and aa.admin_id == ^admin.id
        )

        IO.puts("Artículo #{article.title} rechazado por #{admin.username}")
        {:ok, article}

      _ -> {:error, :invalid_decision}
    end
  end
end
