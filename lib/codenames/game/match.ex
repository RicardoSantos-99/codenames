defmodule Codenames.Game.Match do
  defstruct [:room_id, :players, :board, :round, :admin, :total_players]

  alias Codenames.Words

  def new(room_id, admin, board) do
    %__MODULE__{
      room_id: room_id,
      players: [admin],
      board: board,
      round: 0,
      admin: admin,
      total_players: 1
    }
  end

  def add_player(match, email) when is_binary(email) do
    if Enum.member?(match.players, email) do
      match
    else
      %__MODULE__{
        match
        | players: [email | match.players],
          total_players: match.total_players + 1
      }
      |> Map.update!(:board, fn board ->
        if board.blue_team.players <= board.red_team.players do
          %{board | blue_team: %{board.blue_team | players: [email | board.blue_team.players]}}
        else
          %{board | red_team: %{board.red_team | players: [email | board.red_team.players]}}
        end
      end)
    end
  end

  def build_game_board(user) do
    all_words = random_words_from_db()

    starting_team = Enum.random([:blue, :red])

    {blue_words, after_blue} =
      take_random_words(all_words, if(starting_team == :blue, do: 9, else: 8))

    {red_words, after_red} =
      take_random_words(after_blue, if(starting_team == :blue, do: 8, else: 9))

    {neutral_words, after_neutral} = take_random_words(after_red, 7)
    {black_word, _} = take_random_words(after_neutral, 1)

    %{
      starting_team: starting_team,
      blue_team: %{words: blue_words, players: [user.email], spymaster: nil},
      red_team: %{words: red_words, players: [], spymaster: nil},
      words: all_words(red_words, blue_words, neutral_words, black_word) |> Enum.shuffle()
    }
  end

  def player_is_spymaster?(match, email) do
    match.blue_team.spymaster == email || match.red_team.spymaster == email
  end

  defp put_in_team(match, email, team) do
    Map.update!(match, team, fn team ->
      %{team | players: [email | team.players]}
    end)
  end

  defp remove_from_team(match, email, team) do
    Map.update!(match, team, fn team ->
      %{team | players: List.delete(team.players, email)}
    end)
  end

  defp already_in_team?(team, match, email) do
    Enum.member?(match[team].players, email)
  end

  def join_operative(match, email, "blue") do
    if player_is_spymaster?(match, email) do
      {:error, "You are already a spymaster"}
    else
      if already_in_team?(:blue_team, match, email) do
        {:error, "You are already in the blue team"}
      else
        {:ok,
         match
         |> put_in_team(email, :blue_team)
         |> remove_from_team(email, :red_team)}
      end
    end
  end

  def join_operative(match, email, "red") do
    if player_is_spymaster?(match, email) do
      {:error, "You are already a spymaster"}
    else
      if already_in_team?(:red_team, match, email) do
        {:error, "You are already in the red team"}
      else
        {:ok,
         match
         |> put_in_team(email, :red_team)
         |> remove_from_team(email, :blue_team)}
      end
    end
  end

  def join_spymaster(match, email, "blue") when is_nil(match.blue_team.spymaster) do
    if player_is_spymaster?(match, email) do
      match
    else
      Map.update!(match, :blue_team, fn team ->
        %{team | spymaster: email, players: List.delete(team.players, email)}
      end)
    end
  end

  def join_spymaster(match, email, "red") when is_nil(match.red_team.spymaster) do
    if player_is_spymaster?(match, email) do
      match
    else
      Map.update!(match, :red_team, fn team ->
        %{team | spymaster: email, players: List.delete(team.players, email)}
      end)
    end
  end

  def join_spymaster(match, _email, _) do
    match
  end

  def all_words(red, blue, neutral, black) do
    red = Enum.map(red, fn word -> {word, :red} end)
    blue = Enum.map(blue, fn word -> {word, :blue} end)
    neutral = Enum.map(neutral, fn word -> {word, :neutral} end)
    black = [{black, :black}]

    red ++ blue ++ neutral ++ black
  end

  defp random_words_from_db do
    all_words =
      Words.list_words()
      |> Enum.map(fn word -> word.term end)

    Enum.take_random(all_words, 25)
  end

  defp take_random_words(words, count) do
    chosen_words = Enum.take_random(words, count)
    remaining_words = Enum.reject(words, fn word -> word in chosen_words end)
    {chosen_words, remaining_words}
  end
end
