defmodule ArticleManagement.Application do
  @moduledoc """
  Módulo principal de arranque de la aplicación `ArticleManagement`.

  Este módulo inicia el árbol de supervisión de la aplicación, incluyendo el
  repositorio Ecto (`ArticleManagement.Repo`) para la conexión con la base de datos PostgreSQL.

  Aquí también deben añadirse todos los procesos supervisados relevantes del sistema,
  como el `UserManager`, colas de revisión, o servicios de artículos, para mantener
  la disponibilidad y tolerancia a fallos en un entorno distribuido.
  """

  use Application

  def start(_type, _args) do
    IO.puts("Starting ArticleManagement.Repo...")
    children = [
      ArticleManagement.Repo,
      ArticleManagement.UserManager
    ]

    opts = [strategy: :one_for_one, name: ArticleManagement.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
