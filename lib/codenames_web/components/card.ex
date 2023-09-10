defmodule CodenamesWeb.Components.Card do
  use Phoenix.Component

  def card(assigns) do
    ~L"""
    <div class="grid grid-cols-5 gap-2 p-1">
      <%= for {word, color} <- @words do %>
        <div class="w-32 h-32 rounded-lg shadow-md flex items-center justify-center <%= color_class(color) %>">
          <p class="text-xl font-bold uppercase"><%= word %></p>
        </div>
      <% end %>
    </div>
    """
  end

  #  bg-gray-200
  defp color_class(:red), do: "bg-red-400"
  defp color_class(:blue), do: "bg-blue-400"
  defp color_class(:neutral), do: "bg-gray-200"
  defp color_class(:black), do: "bg-pink-400"
end
