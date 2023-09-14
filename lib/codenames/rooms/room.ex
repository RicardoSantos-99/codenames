defmodule Codenames.Rooms.Room do
  @moduledoc """
  Room context
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Codenames.Accounts.User
  alias Ecto.Enum

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @status [:open, :in_progress, :closed]

  schema "rooms" do
    field(:name, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:public, :boolean, default: false)
    field(:status, Enum, values: @status, default: :open)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(room, attrs, opts \\ []) do
    room
    |> cast(attrs, [:name, :status, :public, :user_id])
    |> validate_required([:name, :status, :public, :user_id])
    |> validate_inclusion(:status, @status)
    |> validate_inclusion(:public, [true, false])
    |> validate_password(opts)
  end

  def validate_password(changeset, opts) do
    case get_field(changeset, :password) do
      nil -> changeset
      _ -> User.validate_password(changeset, opts)
    end
  end
end
