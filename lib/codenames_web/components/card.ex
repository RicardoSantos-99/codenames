defmodule CodenamesWeb.Components.Card do
  @moduledoc """
  Card component
  ## Examples

  """
  use Phoenix.Component
  require Codenames.Games.Board
  alias Codenames.Games.Board

  def card(assigns) do
    ~L"""
    <div class="grid grid-cols-5 gap-2 px-2">
      <%= for %{word: word, color: color, revealed: _revealed} <- @board.words do %>
        <div class="w-32 h-32 rounded-lg shadow-md flex items-center justify-center <%= get_color(@board, @user.email, color) %>">
          <p
            class="text-sm font-bold uppercase <%= (color == :black && Board.already_with_spymaster?(@board, @user.email)) && "text-white" %>"
          >
            <%= word %>
          </p>
        </div>
      <% end %>
    </div>
    """
  end

  def get_color(board, email, color) when Board.is_spymaster?(board, email) do
    color_class(color)
  end

  def get_color(_board, _email, _color), do: color_class(:neutral)

  defp color_class(:black), do: "bg-zinc-950"
  defp color_class(:blue), do: "bg-card-blue"
  defp color_class(:neutral), do: "bg-card-gray"
  defp color_class(:red), do: "bg-card-orange"
end
