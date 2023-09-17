defmodule Codenames.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codenames.Players` context.
  """

  @doc """
  Generate a player_room.
  """
  def player_room_fixture(attrs \\ %{}) do
    {:ok, player_room} =
      attrs
      |> Enum.into(%{})
      |> Codenames.Players.create_player_room()

    player_room
  end
end
