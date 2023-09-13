defmodule Codenames.PlayersTest do
  use Codenames.DataCase

  alias Codenames.Players

  describe "players_rooms" do
    alias Codenames.Players.PlayerRoom

    import Codenames.PlayersFixtures

    @invalid_attrs %{}

    test "list_players_rooms/0 returns all players_rooms" do
      player_room = player_room_fixture()
      assert Players.list_players_rooms() == [player_room]
    end

    test "get_player_room!/1 returns the player_room with given id" do
      player_room = player_room_fixture()
      assert Players.get_player_room!(player_room.id) == player_room
    end

    test "create_player_room/1 with valid data creates a player_room" do
      valid_attrs = %{}

      assert {:ok, %PlayerRoom{} = player_room} = Players.create_player_room(valid_attrs)
    end

    test "create_player_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_player_room(@invalid_attrs)
    end

    test "update_player_room/2 with valid data updates the player_room" do
      player_room = player_room_fixture()
      update_attrs = %{}

      assert {:ok, %PlayerRoom{} = player_room} = Players.update_player_room(player_room, update_attrs)
    end

    test "update_player_room/2 with invalid data returns error changeset" do
      player_room = player_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_player_room(player_room, @invalid_attrs)
      assert player_room == Players.get_player_room!(player_room.id)
    end

    test "delete_player_room/1 deletes the player_room" do
      player_room = player_room_fixture()
      assert {:ok, %PlayerRoom{}} = Players.delete_player_room(player_room)
      assert_raise Ecto.NoResultsError, fn -> Players.get_player_room!(player_room.id) end
    end

    test "change_player_room/1 returns a player_room changeset" do
      player_room = player_room_fixture()
      assert %Ecto.Changeset{} = Players.change_player_room(player_room)
    end
  end
end
