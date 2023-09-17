defmodule Codenames.PlayersTest do
  use Codenames.DataCase

  alias Codenames.Players

  describe "players_rooms" do
    alias Codenames.Players.PlayerRoom

    import Codenames.PlayersFixtures
    import Codenames.AccountsFixtures
    import Codenames.RoomsFixtures

    setup %{} do
      user = user_fixture()
      room = room_fixture(%{user_id: user.id})

      %{room: room, user: user}
    end

    @invalid_attrs %{}

    test "list_players_rooms/0 returns all players_rooms", %{room: room, user: user} do
      player_room = player_room_fixture(%{user_id: user.id, room_id: room.id})

      assert Players.list_players_rooms() == [player_room]
    end

    test "get_player_room!/1 returns the player_room with given id", %{room: room, user: user} do
      player_room = player_room_fixture(%{user_id: user.id, room_id: room.id})
      assert Players.get_player_room!(player_room.id) == player_room
    end

    test "create_player_room/1 with valid data creates a player_room", %{room: room, user: user} do
      valid_attrs = %{user_id: user.id, room_id: room.id}

      assert {:ok, %PlayerRoom{}} = Players.create_player_room(valid_attrs)
    end

    test "create_player_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_player_room(@invalid_attrs)
    end

    test "update_player_room/2 with valid data updates the player_room", %{room: room, user: user} do
      player_room = player_room_fixture(%{user_id: user.id, room_id: room.id})
      update_attrs = %{user_id: user.id, room_id: room.id}

      assert {:ok, %PlayerRoom{}} = Players.update_player_room(player_room, update_attrs)
    end

    test "delete_player_room/1 deletes the player_room", %{room: room, user: user} do
      player_room = player_room_fixture(%{user_id: user.id, room_id: room.id})
      assert {:ok, %PlayerRoom{}} = Players.delete_player_room(player_room)
      assert_raise Ecto.NoResultsError, fn -> Players.get_player_room!(player_room.id) end
    end

    test "change_player_room/1 returns a player_room changeset", %{room: room, user: user} do
      player_room = player_room_fixture(%{user_id: user.id, room_id: room.id})
      assert %Ecto.Changeset{} = Players.change_player_room(player_room)
    end
  end
end
