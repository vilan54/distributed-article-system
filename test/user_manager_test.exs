defmodule ArticleManagement.UserManagerTest do
  use ExUnit.Case, async: true

  alias ArticleManagement.{Repo, UserManager}
  alias ArticleManagement.Identity.User

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "create_user/3" do
    test "creates a new user" do
      assert {:ok, %User{} = user} =
               UserManager.create_user("testuser", "password123", :user)

      assert user.username == "testuser"
      assert user.role == :user
    end

    test "prevents duplicate usernames" do
      UserManager.create_user("dupe", "123456")
      assert {:error, :user_already_exists} = UserManager.create_user("dupe", "abcdef")
    end
  end

  describe "get_user/1" do
    test "retrieves existing user" do
      {:ok, user} = UserManager.create_user("whoami", "pwpwpw")
      assert %User{username: "whoami"} = UserManager.get_user("whoami")
    end

    test "returns nil if user not found" do
      assert UserManager.get_user("ghost") == nil
    end
  end

  describe "login/2 and session handling" do
    setup do
      {:ok, user} = UserManager.create_user("login_user", "pwpwpwpw", :admin)
      %{user: user}
    end

    test "succeeds with correct credentials", %{user: user} do
      assert {:ok, %{token: token, role: :admin}} = UserManager.login("login_user", "pwpwpwpw")
      assert UserManager.get_user_by_token(token).id == user.id
    end

    test "fails with incorrect password" do
      UserManager.create_user("failme", "right")
      assert {:error, :invalid_credentials} = UserManager.login("failme", "wrongguy")
    end

    test "logout deletes session", %{user: _user} do
      {:ok, %{token: token}} = UserManager.login("login_user", "pwpwpwpw")
      assert :ok = UserManager.logout(token)
      assert UserManager.get_user_by_token(token) == nil
    end
  end

  describe "delete_user/1" do
    test "deletes existing user" do
      {:ok, user} = UserManager.create_user("deleteme", "pwpwpwpw")
      assert {:ok, _} = UserManager.delete_user("deleteme")
      assert UserManager.get_user("deleteme") == nil
    end

    test "returns error if user not found" do
      assert {:error, :user_not_found} = UserManager.delete_user("nonexistent")
    end
  end

  describe "has_permission?/2" do
    test "admin has admin/user permissions" do
      {:ok, %{token: token}} = UserManager.create_user("admin", "pwpwpwpw", :admin) |> then(fn {:ok, _} -> UserManager.login("admin", "pwpwpwpw") end)
      assert UserManager.has_permission?(token, :admin)
      assert UserManager.has_permission?(token, :user)
    end

    test "user has user but not admin permission" do
      {:ok, %{token: token}} = UserManager.create_user("user", "pwpwpwpw", :user) |> then(fn {:ok, _} -> UserManager.login("user", "pwpwpwpw") end)
      refute UserManager.has_permission?(token, :admin)
      assert UserManager.has_permission?(token, :user)
    end
  end
end
