defmodule ArticleManagement.ArticleManagerTest do
  use ExUnit.Case, async: true
  alias ArticleManagement.{Repo, ArticleManager}
  alias ArticleManagement.Identity.Article
  alias ArticleManagement.Identity.User

  import Ecto.Changeset

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    user =
      %User{}
      |> User.registration_changeset(%{username: "test_user", password: "secretpassword", role: :user})
      |> Repo.insert!()

    {:ok, user: user}
  end

  describe "list_articles/0" do
    test "returns all articles", %{user: user} do
      Repo.insert!(%Article{title: "Demo", content: "content", author_id: user.id})
      articles = ArticleManager.list_articles()
      assert length(articles) == 1
    end
  end

  describe "get_article/1" do
    test "returns the article by ID", %{user: user} do
      article = Repo.insert!(%Article{title: "Title", content: "Body", author_id: user.id})
      assert %Article{id: id} = ArticleManager.get_article(article.id)
      assert id == article.id
    end
  end

  describe "create_article/1" do
    test "creates article with valid permissions", %{user: user} do
      attrs = %{"title" => "New", "content" => "Text", "author_id" => user.id}
      assert {:ok, %Article{} = article} = ArticleManager.create_article(attrs)
      assert article.title == "New"
    end

    test "fails if author not found" do
      assert {:error, :author_not_found} =
               ArticleManager.create_article(%{"title" => "X", "content" => "Y", "author_id" => -1})
    end

    test "fails if no permissions" do
      {:ok, no_perm_user} =
        %User{}
        |> User.registration_changeset(%{username: "low", password: "123456", role: :user})
        |> Repo.insert()

      attrs = %{"title" => "NoPerm", "content" => "Fail", "author_id" => no_perm_user.id}
      assert {:error, :unauthorized} = ArticleManager.create_article(attrs)
    end
  end

  describe "update_article/2" do
    test "updates article fields", %{user: user} do
      article = Repo.insert!(%Article{title: "Old", content: "Content", author_id: user.id, status: "pending_review"})
      assert {:ok, updated} = ArticleManager.update_article(article, %{title: "New"})
      assert updated.title == "New"
    end
  end

  describe "delete_article/1" do
    test "deletes the article", %{user: user} do
      article = Repo.insert!(%Article{title: "ToDelete", content: "Gone", author_id: user.id})
      assert {:ok, %Article{}} = ArticleManager.delete_article(article)
      assert nil == Repo.get(Article, article.id)
    end
  end
end
