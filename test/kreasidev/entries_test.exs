defmodule Kreasidev.EntriesTest do
  use Kreasidev.DataCase

  alias Kreasidev.Entries

  describe "posts" do
    alias Kreasidev.Entries.Post

    import Kreasidev.EntriesFixtures

    @invalid_attrs %{body: nil, slug: nil, title: nil, upvote: nil, url: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Entries.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Entries.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body", slug: "some slug", title: "some title", upvote: 42, url: "some url"}

      assert {:ok, %Post{} = post} = Entries.create_post(valid_attrs)
      assert post.body == "some body"
      assert post.slug == "some slug"
      assert post.title == "some title"
      assert post.upvote == 42
      assert post.url == "some url"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entries.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body", slug: "some updated slug", title: "some updated title", upvote: 43, url: "some updated url"}

      assert {:ok, %Post{} = post} = Entries.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
      assert post.upvote == 43
      assert post.url == "some updated url"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Entries.update_post(post, @invalid_attrs)
      assert post == Entries.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Entries.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Entries.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Entries.change_post(post)
    end
  end
end
