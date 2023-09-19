defmodule CodenamesWeb.Components.Team do
  @moduledoc """
  Team component

  ## Examples
  """
  use Phoenix.Component

  alias Codenames.Games.Board

  def team(assigns) do
    ~L"""
      <div class="w-1/4 <%= color_class(String.to_atom(@name)) %> rounded-lg shadow-md p-4">
        <h2 class="text-xl font-bold text-white">Time <%= String.capitalize(@name) %></h2>
        <%= Enum.count(@team.words)%>
        <div class="mt-4">
          <button
            phx-click="spymaster" phx-value-team="<%= @name %>"
            <%= disable_when_player_is_spymaster(@board, @user.username) %>
          >
            <h3 class="text-lg font-bold text-white underline">
              Spymaster
            </h3>
          </button>
          <p class="text-white"><%= @team.spymaster %></p>
        </div>
        <div class="mt-4">
          <button
            phx-click="operative" phx-value-team="<%= @name %>"
            <%= disable_when_player_is_spymaster(@board, @user.username) %>
          >
            <h3 class="text-lg font-bold text-white underline">Operatives</h3>
          </button>
          <ul>
            <%= for username <- @team.players do %>
              <%= username %>
            <% end %>
          </ul>
        </div>
      </div>
    """
  end

  defp color_class(:red), do: "bg-team-red"
  defp color_class(:blue), do: "bg-team-blue"

  defp disable_when_player_is_spymaster(board, username) do
    if Board.already_with_spymaster?(board, username), do: "disabled", else: ""
  end
end
