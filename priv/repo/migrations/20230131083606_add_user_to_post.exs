defmodule Kreasidev.Repo.Migrations.AddUserToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:user_id, references(:users, on_delete: :nothing))
    end
  end
end
