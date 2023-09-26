defmodule Codenames.Games.Board do
  @moduledoc """
  Board context
  """
  alias Codenames.Games.Board.BoardSchema
  alias Codenames.Games.Team
  alias Codenames.Games.Team.TeamSchema
  alias Codenames.Words

  defguard is_blue_team_smaller(board)
           when length(board.blue_team.players) <= length(board.red_team.players)

  defguard is_spymaster?(board, username)
           when board.red_team.spymaster == username or board.blue_team.spymaster == username

  def build_game_board do
    starting_team = Enum.random([:blue, :red])

    {blue_words_count, red_words_count} =
      case starting_team do
        :blue -> {9, 8}
        :red -> {8, 9}
      end

    blue_words = Words.list_random_words(blue_words_count)
    red_words = Words.list_random_words(red_words_count)
    neutral_words = Words.list_random_words(7)
    black_word = Words.list_random_words(1)

    words = Words.all_words(red_words, blue_words, neutral_words, black_word) |> Enum.shuffle()

    %BoardSchema{
      starting_team: starting_team,
      blue_team: %TeamSchema{words: blue_words, players: [], spymaster: nil},
      red_team: %TeamSchema{words: red_words, players: [], spymaster: nil},
      words: words
    }
  end

  def leave(board, username) do
    cond do
      already_with_operative?(board, username) ->
        remove_player_from_both_teams(board, username)

      already_with_spymaster?(board, username) ->
        remove_spymaster(board, username)

      true ->
        board
    end
  end

  defp remove_spymaster(board, username) do
    team_key = spymaster_team_key(board, username)

    update_spymaster_in_board(board, team_key)
  end

  defp spymaster_team_key(board, username) do
    cond do
      Team.player_is_spymaster?(board.blue_team, username) -> :blue_team
      Team.player_is_spymaster?(board.red_team, username) -> :red_team
      true -> nil
    end
  end

  defp update_spymaster_in_board(board, :blue_team) do
    %{board | blue_team: Team.remove_spymaster(board.blue_team)}
  end

  defp update_spymaster_in_board(board, :red_team) do
    %{board | red_team: Team.remove_spymaster(board.red_team)}
  end

  defp update_spymaster_in_board(board, _), do: board

  def add_player_to_team_with_fewer_players(board, username) when is_blue_team_smaller(board) do
    %{board | blue_team: Team.add_player(board.blue_team, username)}
  end

  def add_player_to_team_with_fewer_players(board, username) do
    %{board | red_team: Team.add_player(board.red_team, username)}
  end

  def join_spymaster(board, username, team_color) when team_color in [:blue, :red] do
    opposing_team = get_opposing_team(board, team_color)
    current_team = get_current_team(board, team_color)

    case Team.player_is_spymaster?(opposing_team, username) || not is_nil(current_team.spymaster) do
      true -> board
      false -> assign_spymaster_to_team(board, current_team, username, team_color)
    end
  end

  def join_operative(board, username, team_color) when team_color in [:blue, :red] do
    team = get_current_team(board, team_color)

    case Team.already_in_team?(team, username) || already_with_spymaster?(board, username) do
      true -> board
      false -> assign_operative_to_team(board, team, username, team_color)
    end
  end

  def already_on_match?(board, username) do
    already_with_operative?(board, username) || already_with_spymaster?(board, username)
  end

  def already_with_operative?(board, username) do
    Enum.member?(board.blue_team.players, username) ||
      Enum.member?(board.red_team.players, username)
  end

  def already_with_spymaster?(%BoardSchema{red_team: red, blue_team: blue}, username) do
    Team.player_is_spymaster?(red, username) || Team.player_is_spymaster?(blue, username)
  end

  defp assign_operative_to_team(board, _team, username, :blue) do
    remove_player_from_both_teams(board, username)
    |> Map.update!(:blue_team, &Team.add_player(&1, username))
  end

  defp assign_operative_to_team(board, _team, username, :red) do
    remove_player_from_both_teams(board, username)
    |> Map.update!(:red_team, &Team.add_player(&1, username))
  end

  defp assign_spymaster_to_team(board, _team, username, :blue) do
    remove_player_from_both_teams(board, username)
    |> Map.update!(:blue_team, &Team.add_spymaster(&1, username))
  end

  defp assign_spymaster_to_team(board, _team, username, :red) do
    remove_player_from_both_teams(board, username)
    |> Map.update!(:red_team, &Team.add_spymaster(&1, username))
  end

  def remove_player_from_both_teams(board, username) do
    board
    |> remove_player_from_team(:blue_team, username)
    |> remove_player_from_team(:red_team, username)
  end

  defp remove_player_from_team(board, team_key, username) do
    Map.update!(board, team_key, &Team.remove_player(&1, username))
  end

  def get_opposing_team(%{red_team: red}, :blue), do: red
  def get_opposing_team(%{blue_team: blue}, :red), do: blue

  def get_current_team(%{blue_team: blue}, :blue), do: blue
  def get_current_team(%{red_team: red}, :red), do: red
end
