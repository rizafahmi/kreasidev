defmodule Kreasidev.Repo.Migrations.AddVoters do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:voters, {:array, :integer})
    end
  end
end
