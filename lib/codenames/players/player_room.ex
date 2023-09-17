defmodule Codenames.Players.PlayerRoom do
  @moduledoc """
  PlayerRoom schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players_rooms" do
    field :user_id, :binary_id
    field :room_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(player_room, attrs) do
    player_room
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end
end
