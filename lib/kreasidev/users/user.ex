defmodule Kreasidev.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :posts, Kreasidev.Entries.Post
    has_many :comments, Kreasidev.Entries.Comment

    timestamps()
  end
end
