defmodule CodenamesWeb.Components.Team do
  use Phoenix.Component

  def team(assigns) do
    ~L"""
      <div class="w-1/4 p-2">
        <div class="bg-blue-500 rounded-lg shadow-md p-4">
          <h2 class="text-xl font-bold text-white">Time Azul</h2>
          <%= Enum.count(@board.blue) %>
          <div class="mt-4">
            <h3 class="text-lg font-bold text-white underline">Spymaster</h3>
            <p class="text-white">
              Spymaster
            </p>
          </div>
          <div class="mt-4">
            <h3 class="text-lg font-bold text-white underline">Operatives</h3>
            <ul>
              user1
            </ul>
          </div>
        </div>
      </div>
    """
  end
end
