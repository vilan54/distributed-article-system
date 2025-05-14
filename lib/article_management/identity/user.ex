defmodule ArticleManagement.Identity.User do
  @moduledoc """
  Esquema que representa un usuario del sistema.

  Los usuarios pueden ser de tipo `:user` o `:admin`, y poseen credenciales
  que les permiten autenticarse y realizar operaciones según su rol.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password_hash, :string
    field :role, Ecto.Enum, values: [:user, :admin]

    timestamps()
  end

  @doc """
  Cambios requeridos para crear un usuario, espera contraseña en texto plano.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:username)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      plain ->
        put_change(changeset, :password_hash, hash(plain))
        |> delete_change(:password)
    end
  end

  defp hash(password), do: :crypto.hash(:sha256, password) |> Base.encode16()
end
