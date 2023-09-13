defmodule Codenames.Games.Board do
  @moduledoc false
  use Ecto.Schema

  alias Codenames.Games.Team

  embedded_schema do
    field(:starting_team, :string)
    embeds_one(:blue_team, Team)
    embeds_one(:red_team, Team)
    field(:words, {:array, :string})
  end
end
