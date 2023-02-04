defmodule Kreasidev.Entries.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    # field :post_id, :id
    belongs_to :post, Kreasidev.Entries.Post
    belongs_to :users, Kreasidev.Accounts.User, references: :id, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body])
  end
end
