defmodule Codenames.Repo.Migrations.CreatePlayersRooms do
  use Ecto.Migration

  def change do
    create table(:players_rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:players_rooms, [:user_id])
    create index(:players_rooms, [:room_id])
  end
end
