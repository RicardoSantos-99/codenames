defmodule Codenames.Board do
  def build_game_board do
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
      blue: blue_words,
      red: red_words,
      words: all_words(red_words, blue_words, neutral_words, black_word) |> Enum.shuffle()
    }
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
      Codenames.Words.list_words()
      |> Enum.map(fn word -> word.term end)

    Enum.take_random(all_words, 25)
  end

  defp take_random_words(words, count) do
    chosen_words = Enum.take_random(words, count)
    remaining_words = Enum.reject(words, fn word -> word in chosen_words end)
    {chosen_words, remaining_words}
  end
end
