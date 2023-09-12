defmodule Codenames.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :hashed_password, :string
      add :status, :string
      add :public, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:rooms, [:user_id])
  end
end
