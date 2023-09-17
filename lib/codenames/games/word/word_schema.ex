defmodule Codenames.Games.Word.WordSchema do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:color, :string)
    field(:revealed, :boolean)
    field(:word, :string)
  end

  def changeset(word, params \\ %{}) do
    word
    |> cast(params, [:color, :revealed, :word])
  end
end
