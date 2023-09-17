defmodule Codenames.Game do
  @moduledoc """
  game context
  """

  alias Codenames.Games.GameSchema
  alias Codenames.Games.Board

  defguard is_admin?(game, email) when game.admin == email

  def player_already_joined?(players, email) do
    Enum.member?(players, email)
  end

  def add_player(%GameSchema{board: board, players: players} = game, email) do
    updated_players = [email | players]
    updated_board = Board.add_player_to_team_with_fewer_players(board, email)

    %{game | players: updated_players, board: updated_board}
  end

  def join(%GameSchema{players: players} = game, email) do
    case player_already_joined?(players, email) do
      true ->
        game

      false ->
        add_player(game, email)
    end
  end

  def start(game, email) when is_admin?(game, email) do
    %{game | status: "started"}
  end

  def start(game, _email), do: game

  def player_is_spymaster?(game, email) do
    game.blue_team.spymaster == email || game.red_team.spymaster == email
  end
end
