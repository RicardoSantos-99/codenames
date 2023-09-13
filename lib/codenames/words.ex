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
  Returns the list of random words.

  ## Examples

      iex> list_random_words(limit)
      [%Word{}, ...]
  """
  def list_random_words(limit) do
    Repo.all(from w in Word, order_by: fragment("RANDOM()"), limit: ^limit, select: w.term)
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

  @doc """
  Returns all words.

  ## Examples

        iex> all_words(red, blue, neutral, black)
        [%{color: :red, revealed: false, word: "Hospedagem"}, ...]
  """
  def all_words(red, blue, neutral, black) do
    red = Enum.map(red, &build_word_map(&1, :red))
    blue = Enum.map(blue, &build_word_map(&1, :blue))
    neutral = Enum.map(neutral, &build_word_map(&1, :neutral))
    black = Enum.map(black, &build_word_map(&1, :black))

    red ++ blue ++ neutral ++ black
  end

  @doc """
  Builds a word map.

  ## Examples

          iex> build_word_map("Hospedagem", :red)
          %{color: :red, revealed: false, word: "Hospedagem"}
  """
  def build_word_map(word, color), do: %{word: word, color: color, revealed: false}
end
