defmodule Codenames.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codenames.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        hashed_password: "some hashed_password",
        name: "some name",
        public: true,
        status: "some status"
      })
      |> Codenames.Rooms.create_room()

    room
  end
end
