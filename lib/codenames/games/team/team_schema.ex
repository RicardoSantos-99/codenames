defmodule Codenames.Games.Team.TeamSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :words, {:array, :string}
    field :players, {:array, :string}, default: []
    field :spymaster, :string
  end

  def changeset(team, params \\ %{}) do
    team
    |> cast(params, [:words, :players, :spymaster])
  end
end
