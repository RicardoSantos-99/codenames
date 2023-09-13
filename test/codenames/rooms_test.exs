defmodule Codenames.RoomsTest do
  use Codenames.DataCase
  alias Codenames.Rooms

  describe "rooms" do
    alias Codenames.Rooms.Room

    import Codenames.RoomsFixtures
    import Codenames.AccountsFixtures

    setup do
      user = user_fixture()
      %{user: user}
    end

    @invalid_attrs %{password: nil, name: nil, public: nil, status: nil}

    test "list_rooms/0 returns all rooms", %{user: user} do
      room = room_fixture(%{user_id: user.id})
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id", %{user: user} do
      room = room_fixture(%{user_id: user.id})
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room", %{user: user} do
      valid_attrs = %{
        name: "some name",
        public: true,
        status: "open",
        user_id: user.id
      }

      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs)
      assert room.hashed_password == nil
      assert room.name == "some name"
      assert room.public == true
      assert room.status == :open
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room", %{user: user} do
      room = room_fixture(%{user_id: user.id})

      update_attrs = %{
        user_id: user.id,
        name: "some updated name",
        public: false,
        status: "open"
      }

      assert {:ok, %Room{} = room} = Rooms.update_room(room, update_attrs)
      assert room.hashed_password == nil
      assert room.name == "some updated name"
      assert room.public == false
      assert room.status == :open
    end

    test "update_room/2 with invalid data returns error changeset", %{user: user} do
      room = room_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room", %{user: user} do
      room = room_fixture(%{user_id: user.id})
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset", %{user: user} do
      room = room_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
