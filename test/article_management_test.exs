defmodule ArticleManagementTest do
  use ExUnit.Case
  doctest ArticleManagement

  test "greets the world" do
    assert ArticleManagement.hello() == :world
  end
end
