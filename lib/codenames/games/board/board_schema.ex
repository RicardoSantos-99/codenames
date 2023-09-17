defmodule Codenames.Games.Board.BoardSchema do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Codenames.Games.Team.TeamSchema
  alias Codenames.Games.Word.WordSchema

  embedded_schema do
    field(:starting_team, :string)
    embeds_one(:blue_team, TeamSchema)
    embeds_one(:red_team, TeamSchema)
    embeds_many(:words, WordSchema)
  end

  def changeset(board, params \\ %{}) do
    board
    |> cast(params, [:starting_team])
    |> cast_embed(:blue_team)
    |> cast_embed(:red_team)
    |> cast_embed(:words)
  end
end
