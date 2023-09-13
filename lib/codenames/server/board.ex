defmodule Codenames.Server.Board do
  @moduledoc """
  Board context
  """
  defstruct [:starting_team, :blue_team, :red_team, :words]
  alias Codenames.Words
  alias Codenames.Server.Team

  defguard is_blue_team_smaller(board)
           when length(board.blue_team.players) <= length(board.red_team.players)

  defguard is_spymaster?(board, email)
           when board.red_team.spymaster == email or board.blue_team.spymaster == email

  def new(starting_team, %Team{} = blue_team, %Team{} = red_team, words) do
    %__MODULE__{
      starting_team: starting_team,
      blue_team: blue_team,
      red_team: red_team,
      words: words
    }
  end

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
    new(starting_team, Team.new(blue_words), Team.new(red_words), words)
  end

  def add_player_to_team_with_fewer_players(board, email) when is_blue_team_smaller(board) do
    %{board | blue_team: Team.add_player(board.blue_team, email)}
  end

  def add_player_to_team_with_fewer_players(board, email) do
    %{board | red_team: Team.add_player(board.red_team, email)}
  end

  def join_spymaster(board, email, team_color) when team_color in [:blue, :red] do
    opposing_team = get_opposing_team(board, team_color)
    current_team = get_current_team(board, team_color)

    case Team.player_is_spymaster?(opposing_team, email) || not is_nil(current_team.spymaster) do
      true -> board
      false -> assign_spymaster_to_team(board, current_team, email, team_color)
    end
  end

  def join_operative(board, email, team_color) when team_color in [:blue, :red] do
    team = get_current_team(board, team_color)

    case Team.already_in_team?(team, email) || already_with_spymaster?(board, email) do
      true -> board
      false -> assign_operative_to_team(board, team, email, team_color)
    end
  end

  def already_on_match?(board, email) do
    already_with_operative?(board, email) || already_with_spymaster?(board, email)
  end

  def already_with_operative?(board, email) do
    Enum.member?(board.blue_team.players, email) || Enum.member?(board.red_team.players, email)
  end

  def already_with_spymaster?(%__MODULE__{red_team: red, blue_team: blue}, email) do
    Team.player_is_spymaster?(red, email) || Team.player_is_spymaster?(blue, email)
  end

  defp assign_operative_to_team(board, _team, email, :blue) do
    remove_player_from_both_teams(board, email)
    |> Map.update!(:blue_team, &Team.add_player(&1, email))
  end

  defp assign_operative_to_team(board, _team, email, :red) do
    remove_player_from_both_teams(board, email)
    |> Map.update!(:red_team, &Team.add_player(&1, email))
  end

  defp assign_spymaster_to_team(board, _team, email, :blue) do
    remove_player_from_both_teams(board, email)
    |> Map.update!(:blue_team, &Team.add_spymaster(&1, email))
  end

  defp assign_spymaster_to_team(board, _team, email, :red) do
    remove_player_from_both_teams(board, email)
    |> Map.update!(:red_team, &Team.add_spymaster(&1, email))
  end

  def remove_player_from_both_teams(board, email) do
    board
    |> remove_player_from_team(:blue_team, email)
    |> remove_player_from_team(:red_team, email)
  end

  defp remove_player_from_team(board, team_key, email) do
    Map.update!(board, team_key, &Team.remove_player(&1, email))
  end

  def get_opposing_team(%{red_team: red}, :blue), do: red
  def get_opposing_team(%{blue_team: blue}, :red), do: blue

  def get_current_team(%{blue_team: blue}, :blue), do: blue
  def get_current_team(%{red_team: red}, :red), do: red
end
