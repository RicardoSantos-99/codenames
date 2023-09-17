defmodule Codenames.GamesTest do
  use Codenames.DataCase
  @moduletag :game_test

  alias Codenames.Games

  describe "games" do
    alias Codenames.Games.GameSchema
    alias Ecto.{Changeset, NoResultsError}

    import Codenames.GamesFixtures
    import Codenames.AccountsFixtures
    import Codenames.RoomsFixtures

    @invalid_attrs %{board: nil, round: nil, status: nil, admin_id: nil, room_id: nil}

    setup %{} do
      user = user_fixture()

      room = room_fixture(%{user_id: user.id})

      game = game_fixture(%{admin_id: user.id, room_id: room.id})

      %{game: game, user: user, room: room}
    end

    test "list_games/0 returns all games", %{game: game} do
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id", %{game: game} do
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game", %{user: user, room: room} do
      board = board_fixture()

      valid_attrs = %{
        board: board,
        round: 42,
        status: "some status",
        admin_id: user.id,
        room_id: room.id
      }

      assert {:ok, %GameSchema{} = game} = Games.create_game(valid_attrs)
      assert game.round == 42
      assert game.status == "some status"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game", %{game: game, user: user, room: room} do
      board =
        Map.update!(game.board, :starting_team, fn _ -> "red" end)
        |> deep_to_map()

      update_attrs = %{
        board: board,
        round: 43,
        status: "some updated status",
        admin_id: user.id,
        room_id: room.id
      }

      assert {:ok, %GameSchema{} = game} = Games.update_game(game, update_attrs)
      assert game.board |> deep_to_map() == board
      assert game.round == 43
      assert game.status == "some updated status"
    end

    test "update_game/2 with invalid data returns error changeset", %{game: game} do
      board = Map.update!(game.board, :starting_team, fn _ -> "red" end) |> deep_to_map()
      attrs = %{@invalid_attrs | board: board}

      assert {:error, %Changeset{}} = Games.update_game(game, attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game", %{game: game} do
      assert {:ok, %GameSchema{}} = Games.delete_game(game)
      assert_raise NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset", %{game: game} do
      assert %Changeset{} = Games.change_game(game)
    end
  end
end
