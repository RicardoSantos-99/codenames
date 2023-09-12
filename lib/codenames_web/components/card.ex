defmodule CodenamesWeb.Components.Card do
  use Phoenix.Component

  def card(assigns) do
    ~L"""
    <div class="grid grid-cols-5 gap-2 p-1">
      <%= for %{word: word, color: color, revealed: _revealed} <- @board.words do %>
        <div class="w-32 h-32 rounded-lg shadow-md flex items-center justify-center <%= color_class(color) %>">
          <p class="text-xl font-bold uppercase <%= color == :black && "text-white" %>"><%= word %></p>
        </div>
      <% end %>
    </div>
    """
  end

  defp color_class(:black), do: "bg-zinc-950"
  defp color_class(:blue), do: "bg-blue-400"
  defp color_class(:neutral), do: "bg-gray-200"
  defp color_class(:red), do: "bg-red-400"
end
