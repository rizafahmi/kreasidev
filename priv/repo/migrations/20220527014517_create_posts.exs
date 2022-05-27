defmodule Kreasidev.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :url, :string
      add :body, :text
      add :upvote, :integer
      add :slug, :string

      timestamps()
    end
  end
end
