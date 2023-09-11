defmodule CodenamesWeb.Components.Team do
  use Phoenix.Component

  def team(assigns) do
    ~L"""
      <div class="w-1/4 p-2">
        <div class="<%= color_class(String.to_atom(@team)) %> rounded-lg shadow-md p-4">
          <h2 class="text-xl font-bold text-white">Time <%= String.capitalize(@team) %></h2>
          <%= if @team == "blue", do: Enum.count(@board.blue_team.words), else: Enum.count(@board.red_team.words) %>
          <div class="mt-4">
          <button phx-click="spymaster" phx-value-team="<%= @team %>">
            <h3 class="text-lg font-bold text-white underline">
              Spymaster
            </h3>
          </button>
            <p class="text-white">


            </p>
          </div>
          <div class="mt-4">
            <h3 class="text-lg font-bold text-white underline">Operatives</h3>
            <ul>
              <%= if @team == "blue" do
                for _ <- @board.blue_team.players do
                    Enum.random(faces())
                end
                else
                  for _ <- @board.red_team.players do
                    Enum.random(faces())
                  end
                end
                %>
            </ul>
          </div>
        </div>
      </div>
    """
  end

  defp color_class(:red), do: "bg-red-400"
  defp color_class(:blue), do: "bg-blue-400"

  def faces do
    ["😀", "😂", "🤠"]
  end
end
