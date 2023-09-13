defmodule Codenames.Games.Team do
  @moduledoc false
  use Ecto.Schema

  embedded_schema do
    field :words, {:array, :string}
    field :players, {:array, :string}
    field :spymaster, :string
  end
end
