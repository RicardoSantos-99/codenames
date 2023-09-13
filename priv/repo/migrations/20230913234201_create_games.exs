defmodule Codenames.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :round, :integer
      add :status, :string
      add :board, :map
      add :room_id, references(:rooms, on_delete: :nothing, type: :binary_id)
      add :admin_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:games, [:room_id])
    create index(:games, [:admin_id])
  end
end
