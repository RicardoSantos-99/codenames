defmodule Codenames.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codenames.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    board = board_fixture()

    {:ok, game} =
      attrs
      |> Enum.into(%{
        board: board,
        round: 42,
        status: "some status"
      })
      |> Codenames.Games.create_game()

    game
  end

  def board_fixture do
    %{
      starting_team: "blue",
      blue_team: %{
        words: [
          "Sapato",
          "Abóbora",
          "Dinossauro",
          "Xadrez",
          "Ovelha",
          "Bola",
          "Mamão",
          "Zumbi",
          "Elefante"
        ],
        players: [],
        spymaster: "user"
      },
      red_team: %{
        words: ["Ornamento", "Mamão", "Igreja", "Ketchup", "Lobo", "Dente", "Rosa", "Pássaro"],
        players: [],
        spymaster: "user3"
      },
      words: [
        %{color: "neutral", revealed: false, word: "Sapato"}
      ]
    }
  end

  def deep_to_map(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> Enum.map(fn
      {k, %_{} = v} -> {k, deep_to_map(v)}
      {k, v} when is_list(v) -> {k, Enum.map(v, &deep_to_map(&1))}
      {k, v} -> {k, v}
    end)
    |> Enum.into(%{})
  end

  def deep_to_map(value) when is_list(value), do: Enum.map(value, &deep_to_map(&1))
  def deep_to_map(value), do: value
end
