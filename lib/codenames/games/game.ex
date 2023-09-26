defmodule Codenames.Game do
  @moduledoc """
  game context
  """

  alias Codenames.Games.GameSchema

  defguard is_admin?(game, username) when game.admin == username

  def player_already_joined?(players, username) do
    Enum.member?(players, username)
  end

  def add_player(%GameSchema{players: players} = game, username) do
    %{game | players: [username | players]}
  end

  def join(%GameSchema{players: players} = game, username) do
    case player_already_joined?(players, username) do
      true ->
        game

      false ->
        add_player(game, username)
    end
  end

  def start(game, username) when is_admin?(game, username) do
    %{game | status: "started"}
  end

  def start(game, _username), do: game

  def player_is_spymaster?(game, username) do
    game.blue_team.spymaster == username || game.red_team.spymaster == username
  end
end
