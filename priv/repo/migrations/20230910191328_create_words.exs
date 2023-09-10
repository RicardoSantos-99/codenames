defmodule Codenames.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :term, :string

      timestamps()
    end

    create unique_index(:words, [:term])
  end
end
