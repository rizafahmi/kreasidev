defmodule Kreasidev.Repo.Migrations.AddUserToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:user_id, references(:users, on_delete: :nothing))
    end
  end
end
