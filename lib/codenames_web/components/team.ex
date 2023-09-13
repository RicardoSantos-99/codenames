defmodule CodenamesWeb.Components.Team do
  @moduledoc """
  Team component

  ## Examples
  """
  use Phoenix.Component

  alias Codenames.Game.{Team, Board}

  attr :board, :map, required: true
  attr :user, :map, required: true
  attr :team, :string, required: true
  attr :module, :atom, default: Team

  def team(assigns) do
    ~L"""
      <div class="w-1/4 p-2">
        <div class="<%= color_class(String.to_atom(@team)) %> rounded-lg shadow-md p-4">
          <h2 class="text-xl font-bold text-white">Time <%= String.capitalize(@team) %></h2>
          <%= if @team == "blue", do: Enum.count(@board.blue_team.words), else: Enum.count(@board.red_team.words) %>
          <div class="mt-4">
            <button phx-click="spymaster" phx-value-team="<%= @team %>" <%= disable_when_player_is_spymaster(@board, @user.email) %>>
              <h3 class="text-lg font-bold text-white underline">
                Spymaster
              </h3>
            </button>
            <p class="text-white"><%= join_spymaster(@board, @team) %></p>
          </div>
          <div class="mt-4">
            <button phx-click="operative" phx-value-team="<%= @team %>" <%= disable_when_player_is_spymaster(@board, @user.email) %>>
              <h3 class="text-lg font-bold text-white underline">
                Operatives
              </h3>
            </button>
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
  defp faces, do: ["😀", "😂", "🤠"]

  defp join_spymaster(board, "blue") do
    if board.blue_team.spymaster, do: "🤖", else: ""
  end

  defp join_spymaster(board, "red") do
    if board.red_team.spymaster, do: "🤖", else: ""
  end

  defp join_spymaster(_, _), do: ""

  defp disable_when_player_is_spymaster(board, email) do
    if Board.already_with_spymaster?(board, email), do: "disabled", else: ""
  end
end
