defmodule Kreasidev.EntriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kreasidev.Entries` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        slug: "some slug",
        title: "some title",
        upvote: 42,
        url: "some url"
      })
      |> Kreasidev.Entries.create_post()

    post
  end
end
