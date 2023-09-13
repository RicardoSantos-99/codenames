defmodule Codenames.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codenames.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        board: %{},
        round: 42,
        status: "some status"
      })
      |> Codenames.Games.create_game()

    game
  end
end
