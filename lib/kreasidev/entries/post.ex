defmodule Kreasidev.Entries.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :slug, :string
    field :title, :string
    field :upvote, :integer, default: 0
    field :url, :string
    field :voters, {:array, :integer}
    has_many :comments, Kreasidev.Entries.Comment
    belongs_to :users, Kreasidev.Accounts.User, references: :id, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :url, :body, :upvote, :slug, :user_id, :voters])
    |> validate_required([:title])
  end
end
