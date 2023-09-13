defmodule Codenames.Words.Word do
  @moduledoc """
  Word context
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :term, :string

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:term])
    |> validate_required([:term])
  end
end
