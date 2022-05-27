defmodule Kreasidev.Entries.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :slug, :string
    field :title, :string
    field :upvote, :integer, default: 0
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :url, :body, :upvote, :slug])
    |> validate_required([:title, :upvote])
  end
end
