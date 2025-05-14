defmodule ArticleManagement.ArticleManagerTest do
  use ExUnit.Case, async: true
  alias ArticleManagement.{Repo, ArticleManager}
  alias ArticleManagement.Content.Article
  alias ArticleManagement.Accounts.User

  import Ecto.Changeset

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    user =
      %User{}
      |> User.registration_changeset(%{username: "test_user", password: "secret", role: :admin})
      |> Repo.insert!()

    {:ok, user: user}
  end

  describe "list_articles/0" do
    test "returns all articles", %{user: user} do
      Repo.insert!(%Article{title: "Demo", body: "content", author_id: user.id})
      articles = ArticleManager.list_articles()
      assert length(articles) == 1
    end
  end

  describe "get_article/1" do
    test "returns the article by ID", %{user: user} do
      article = Repo.insert!(%Article{title: "Title", body: "Body", author_id: user.id})
      assert %Article{id: ^article.id} = ArticleManager.get_article(article.id)
    end
  end

  describe "create_article/1" do
    test "creates article with valid permissions", %{user: user} do
      attrs = %{"title" => "New", "body" => "Text", "author_id" => user.id}
      assert {:ok, %Article{} = article} = ArticleManager.create_article(attrs)
      assert article.title == "New"
    end

    test "fails if author not found" do
      assert {:error, :author_not_found} =
               ArticleManager.create_article(%{"title" => "X", "body" => "Y", "author_id" => -1})
    end

    test "fails if no permissions" do
      {:ok, no_perm_user} =
        %User{}
        |> User.registration_changeset(%{username: "low", password: "1234", role: :guest})
        |> Repo.insert()

      attrs = %{"title" => "NoPerm", "body" => "Fail", "author_id" => no_perm_user.id}
      assert {:error, :unauthorized} = ArticleManager.create_article(attrs)
    end
  end

  describe "update_article/2" do
    test "updates article fields", %{user: user} do
      article = Repo.insert!(%Article{title: "Old", body: "Content", author_id: user.id})
      assert {:ok, updated} = ArticleManager.update_article(article, %{title: "New"})
      assert updated.title == "New"
    end
  end

  describe "delete_article/1" do
    test "deletes the article", %{user: user} do
      article = Repo.insert!(%Article{title: "ToDelete", body: "Gone", author_id: user.id})
      assert {:ok, %Article{}} = ArticleManager.delete_article(article)
      assert nil == Repo.get(Article, article.id)
    end
  end
end
