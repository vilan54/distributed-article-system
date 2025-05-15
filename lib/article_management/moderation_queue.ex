defmodule ArticleManagement.ModerationQueue do
  @moduledoc """
  Módulo para manejar la cola de artículos pendientes de moderación.

  La cola se basa en los artículos con estado `:pending_review`,
  ordenados cronológicamente por su `inserted_at`.
  """

  import Ecto.Query
  alias ArticleManagement.{Repo, Identity.Article}

  @doc """
  Devuelve el siguiente artículo pendiente de revisión.
  Si no hay artículos pendientes, devuelve `nil`.
  """
  def dequeue do
    Article
    |> where([a], a.status == :pending_review)
    |> order_by(asc: :inserted_at)
    |> limit(1)
    |> Repo.one()
    |> case do
      nil -> nil
      article -> article.id
    end
  end

  @doc """
  No hace falta `enqueue` explícito porque insertar un artículo
  con estado `:pending_review` ya lo posiciona automáticamente en la cola.
  """
  def enqueue(_article_id), do: :ok
end
