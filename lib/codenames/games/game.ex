defmodule Codenames.Games.Game do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Codenames.Games.Board
  alias Codenames.Rooms.Room
  alias Codenames.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    embeds_one :board, Board
    field :round, :integer
    field :status, :string
    belongs_to :admin, User
    belongs_to :room, Room

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:round, :status, :board])
    |> validate_required([:round, :status, :board])
  end
end
