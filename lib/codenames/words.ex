defmodule Codenames.Words do
  @moduledoc """
  The Words context.
  """

  import Ecto.Query, warn: false
  alias Codenames.Repo

  alias Codenames.Words.Word

  @doc """
  Returns the list of words.

  ## Examples

      iex> list_words()
      [%Word{}, ...]

  """
  def list_words do
    Repo.all(Word)
  end

  @doc """
  Gets a single word.

  Raises `Ecto.NoResultsError` if the Word does not exist.

  ## Examples

      iex> get_word!(123)
      %Word{}

      iex> get_word!(456)
      ** (Ecto.NoResultsError)

  """
  def get_word!(id), do: Repo.get!(Word, id)

  @doc """
  Creates a word.

  ## Examples

      iex> create_word(%{field: value})
      {:ok, %Word{}}

      iex> create_word(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_word(attrs \\ %{}) do
    %Word{}
    |> Word.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a word.

  ## Examples

      iex> update_word(word, %{field: new_value})
      {:ok, %Word{}}

      iex> update_word(word, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_word(%Word{} = word, attrs) do
    word
    |> Word.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a word.

  ## Examples

      iex> delete_word(word)
      {:ok, %Word{}}

      iex> delete_word(word)
      {:error, %Ecto.Changeset{}}

  """
  def delete_word(%Word{} = word) do
    Repo.delete(word)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking word changes.

  ## Examples

      iex> change_word(word)
      %Ecto.Changeset{data: %Word{}}

  """
  def change_word(%Word{} = word, attrs \\ %{}) do
    Word.changeset(word, attrs)
  end

  def random_words_from_db do
    all_words =
      list_words()
      |> Enum.map(fn word -> word.term end)

    Enum.take_random(all_words, 25)
  end

  def take_random_words(words, count) do
    chosen_words = Enum.take_random(words, count)
    remaining_words = Enum.reject(words, fn word -> word in chosen_words end)
    {chosen_words, remaining_words}
  end

  defp build_word_map(word, color), do: %{word: word, color: color, revealed: false}

  def all_words(red, blue, neutral, black) do
    red = Enum.map(red, &build_word_map(&1, :red))
    blue = Enum.map(blue, &build_word_map(&1, :blue))
    neutral = Enum.map(neutral, &build_word_map(&1, :neutral))
    black = Enum.map(black, &build_word_map(&1, :black))

    red ++ blue ++ neutral ++ black
  end
end
