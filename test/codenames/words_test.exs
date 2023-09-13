defmodule Codenames.WordsTest do
  @moduledoc false
  use ExUnit.Case
  @moduletag :word_test

  use Codenames.DataCase

  alias Codenames.Words

  describe "words" do
    alias Codenames.Words.Word

    import Codenames.WordsFixtures

    @invalid_attrs %{term: nil}

    test "list_words/0 returns all words" do
      word = word_fixture()
      assert Words.list_words() == [word]
    end

    test "list_random_words/1 returns all words" do
      word_fixture()
      assert Enum.count(Words.list_random_words(1)) == 1
      assert Enum.empty?(Words.list_random_words(0))
    end

    test "get_word!/1 returns the word with given id" do
      word = word_fixture()
      assert Words.get_word!(word.id) == word
    end

    test "create_word/1 with valid data creates a word" do
      valid_attrs = %{term: "some term"}

      assert {:ok, %Word{} = word} = Words.create_word(valid_attrs)
      assert word.term == "some term"
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Words.create_word(@invalid_attrs)
    end

    test "update_word/2 with valid data updates the word" do
      word = word_fixture()
      update_attrs = %{term: "some updated term"}

      assert {:ok, %Word{} = word} = Words.update_word(word, update_attrs)
      assert word.term == "some updated term"
    end

    test "update_word/2 with invalid data returns error changeset" do
      word = word_fixture()
      assert {:error, %Ecto.Changeset{}} = Words.update_word(word, @invalid_attrs)
      assert word == Words.get_word!(word.id)
    end

    test "delete_word/1 deletes the word" do
      word = word_fixture()
      assert {:ok, %Word{}} = Words.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> Words.get_word!(word.id) end
    end

    test "change_word/1 returns a word changeset" do
      word = word_fixture()
      assert %Ecto.Changeset{} = Words.change_word(word)
    end

    test "all_words/4 returns all words" do
      [red, blue, neutral, black] = Words.all_words(["some1"], ["some2"], ["some3"], ["some4"])

      assert red.word == "some1"
      assert red.revealed == false
      assert red.color == :red

      assert blue.word == "some2"
      assert blue.revealed == false
      assert blue.color == :blue

      assert neutral.word == "some3"
      assert neutral.revealed == false
      assert neutral.color == :neutral

      assert black.word == "some4"
      assert black.revealed == false
      assert black.color == :black
    end

    test "build_word_map/2 builds a word map" do
      assert Words.build_word_map("some1", :red) == %{color: :red, revealed: false, word: "some1"}
    end
  end
end
