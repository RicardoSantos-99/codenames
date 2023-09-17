defmodule Codenames.Games.GameSchema do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Codenames.Games.Board.BoardSchema
  alias Codenames.Rooms.Room
  alias Codenames.Accounts.User

  @required_params [:round, :status, :admin_id, :room_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    embeds_one :board, BoardSchema
    field :round, :integer
    field :status, :string
    field :players, {:array, :string}, default: [], virtual: true
    belongs_to :admin, User
    belongs_to :room, Room

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, @required_params)
    |> cast_embed(:board)
    |> validate_required(@required_params ++ [:board])
  end
end
