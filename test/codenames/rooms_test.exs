defmodule Codenames.RoomsTest do
  use Codenames.DataCase

  alias Codenames.Rooms

  describe "rooms" do
    alias Codenames.Rooms.Room

    import Codenames.RoomsFixtures

    @invalid_attrs %{hashed_password: nil, name: nil, public: nil, status: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{
        hashed_password: "some hashed_password",
        name: "some name",
        public: true,
        status: "some status"
      }

      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs)
      assert room.hashed_password == "some hashed_password"
      assert room.name == "some name"
      assert room.public == true
      assert room.status == "some status"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()

      update_attrs = %{
        hashed_password: "some updated hashed_password",
        name: "some updated name",
        public: false,
        status: "some updated status"
      }

      assert {:ok, %Room{} = room} = Rooms.update_room(room, update_attrs)
      assert room.hashed_password == "some updated hashed_password"
      assert room.name == "some updated name"
      assert room.public == false
      assert room.status == "some updated status"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
