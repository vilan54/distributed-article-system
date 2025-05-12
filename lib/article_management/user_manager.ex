defmodule ArticleManagement.UserManager do
  @moduledoc """
  Módulo central de gestión de usuarios, autenticación, sesiones y permisos.

  Utiliza PostgreSQL para persistencia de usuarios mediante Ecto.
  Las sesiones se gestionan en memoria con ETS.
  """

  alias ArticleManagement.Repo
  alias ArticleManagement.Accounts.User

  @session_table :sessions

  ## === Inicialización de la ETS de sesiones ===

  def start_link do
    unless :ets.whereis(@session_table) != :undefined do
      :ets.new(@session_table, [:named_table, :set, :public, read_concurrency: true])
    end

    {:ok, self()}
  end

  ## === Gestión de usuarios ===

  @doc """
  Crea un nuevo usuario. Previene duplicados por username.
  """
  def create_user(username, password, role \\ :user) when role in [:user, :admin] do
    case get_user(username) do
      nil ->
        %User{}
        |> User.registration_changeset(%{username: username, password: password, role: role})
        |> Repo.insert()

      _ ->
        {:error, :user_already_exists}
    end
  end

  @doc """
  Elimina un usuario si existe.
  """
  def delete_user(username) do
    case get_user(username) do
      nil -> {:error, :user_not_found}
      user -> Repo.delete(user)
    end
  end

  @doc """
  Obtiene un usuario por su nombre de usuario.
  """
  def get_user(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Lista todos los usuarios.
  """
  def list_users do
    Repo.all(User)
  end

  ## === Autenticación y sesiones ===

  @doc """
  Verifica credenciales y crea sesión si son válidas.
  """
  def login(username, password) do
    with %User{password_hash: stored_hash} = user <- get_user(username),
         true <- stored_hash == hash(password) do
      token = generate_token()
      :ets.insert(@session_table, {token, username})
      {:ok, %{token: token, role: user.role}}
    else
      _ -> {:error, :invalid_credentials}
    end
  end

  @doc """
  Cierra sesión eliminando el token.
  """
  def logout(token) do
    :ets.delete(@session_table, token)
    :ok
  end

  @doc """
  Obtiene el usuario a partir de un token de sesión.
  """
  def get_user_by_token(token) do
    case :ets.lookup(@session_table, token) do
      [{^token, username}] -> get_user(username)
      _ -> nil
    end
  end

  ## === Permisos ===

  @doc """
  Verifica que rol tiene el usuario
  """
  def has_permission?(token, :admin) do
    case get_user_by_token(token) do
      %User{role: :admin} -> true
      _ -> false
    end
  end
  def has_permission?(token, :user) do
    case get_user_by_token(token) do
      %User{role: role} when role in [:user, :admin] -> true
      _ -> false
    end
  end

  ## === Utilidades privadas ===

  defp hash(password), do: :crypto.hash(:sha256, password) |> Base.encode16()
  defp generate_token, do: :crypto.strong_rand_bytes(16) |> Base.encode16()
end
