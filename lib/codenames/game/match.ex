defmodule Codenames.Game.Match do
  defstruct [:room_id, :players, :board, :round, :admin, :total_players]
  alias Codenames.Game.Board

  def new(room_id, admin, %Board{} = board) do
    %__MODULE__{
      room_id: room_id,
      players: [admin],
      board: board,
      round: 0,
      admin: admin,
      total_players: 1
    }
  end

  def player_already_joined?(players, email) do
    Enum.member?(players, email)
  end

  def add_player(%__MODULE__{board: board, players: players} = match, email) do
    updated_players = [email | players]
    updated_board = Board.add_player_to_team_with_fewer_players(board, email)

    %{
      match
      | players: updated_players,
        total_players: match.total_players + 1,
        board: updated_board
    }
  end

  def join(%__MODULE__{players: players} = match, email) do
    case player_already_joined?(players, email) do
      true ->
        match

      false ->
        add_player(match, email)
    end
  end

  def player_is_spymaster?(match, email) do
    match.blue_team.spymaster == email || match.red_team.spymaster == email
  end
end
