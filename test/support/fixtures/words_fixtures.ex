defmodule Codenames.WordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codenames.Words` context.
  """

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        term: "some term"
      })
      |> Codenames.Words.create_word()

    word
  end
end
