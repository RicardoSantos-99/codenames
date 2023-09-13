defmodule Codenames.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias Codenames.Repo

  alias Codenames.Players.PlayerRoom

  @doc """
  Returns the list of players_rooms.

  ## Examples

      iex> list_players_rooms()
      [%PlayerRoom{}, ...]

  """
  def list_players_rooms do
    Repo.all(PlayerRoom)
  end

  @doc """
  Gets a single player_room.

  Raises `Ecto.NoResultsError` if the Player room does not exist.

  ## Examples

      iex> get_player_room!(123)
      %PlayerRoom{}

      iex> get_player_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_room!(id), do: Repo.get!(PlayerRoom, id)

  @doc """
  Creates a player_room.

  ## Examples

      iex> create_player_room(%{field: value})
      {:ok, %PlayerRoom{}}

      iex> create_player_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_room(attrs \\ %{}) do
    %PlayerRoom{}
    |> PlayerRoom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player_room.

  ## Examples

      iex> update_player_room(player_room, %{field: new_value})
      {:ok, %PlayerRoom{}}

      iex> update_player_room(player_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_room(%PlayerRoom{} = player_room, attrs) do
    player_room
    |> PlayerRoom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player_room.

  ## Examples

      iex> delete_player_room(player_room)
      {:ok, %PlayerRoom{}}

      iex> delete_player_room(player_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_room(%PlayerRoom{} = player_room) do
    Repo.delete(player_room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_room changes.

  ## Examples

      iex> change_player_room(player_room)
      %Ecto.Changeset{data: %PlayerRoom{}}

  """
  def change_player_room(%PlayerRoom{} = player_room, attrs \\ %{}) do
    PlayerRoom.changeset(player_room, attrs)
  end
end
