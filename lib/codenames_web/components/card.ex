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
        <div class="w-32 h-32 rounded-lg shadow-md flex items-center justify-center <%= get_color(@board, @user.username, color) %>">
          <p
            class="text-sm font-bold uppercase <%= (color == :black && Board.already_with_spymaster?(@board, @user.username)) && "text-white" %>"
          >
            <%= word %>
          </p>
        </div>
      <% end %>
    </div>
    """
  end

  def get_color(board, username, color) when Board.is_spymaster?(board, username) do
    color_class(color)
  end

  def get_color(_board, _username, _color), do: color_class(:neutral)

  defp color_class(:black), do: "bg-zinc-950"
  defp color_class(:blue), do: "bg-card-blue"
  defp color_class(:neutral), do: "bg-card-gray"
  defp color_class(:red), do: "bg-card-orange"
end
