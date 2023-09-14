defmodule Codenames.Repo.Migrations.AddUsername do
  @moduledoc false

  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
    end
  end
end
