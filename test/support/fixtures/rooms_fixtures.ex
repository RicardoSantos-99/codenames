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
        password: "Password123!",
        name: "some name",
        public: true,
        status: "open"
      })
      |> Codenames.Rooms.create_room()

    room
  end
end
