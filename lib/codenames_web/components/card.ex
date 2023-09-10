defmodule CodenamesWeb.Components.Card do
  use Phoenix.Component

  def card(assigns) do
    ~L"""
    <div class="grid grid-cols-5 gap-2 p-1">
      <%= for word <- @words do %>
        <div class="w-32 h-32 bg-gray-200 rounded-lg shadow-md flex items-center justify-center">
          <p class="text-xl font-bold uppercase"><%= word %></p>
        </div>
      <% end %>
    </div>
    """
  end
end
