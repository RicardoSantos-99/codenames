defmodule CodenamesWeb.Components.Card do
  @moduledoc """
  Card component
  ## Examples

  """
  use Phoenix.Component
  require Codenames.Server.Board
  alias Codenames.Server.Board

  def card(assigns) do
    ~L"""
    <div class="grid grid-cols-5 gap-2 p-1">
      <%= for %{word: word, color: color, revealed: _revealed} <- @board.words do %>
        <div class="w-32 h-32 rounded-lg shadow-md flex items-center justify-center <%= get_color(@board, @user.email, color) %>">
          <p
            class="text-xl font-bold uppercase <%= (color == :black && Board.already_with_spymaster?(@board, @user.email)) && "text-white" %>"
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
  defp color_class(:blue), do: "bg-blue-400"
  defp color_class(:neutral), do: "bg-gray-200"
  defp color_class(:red), do: "bg-red-400"
end
