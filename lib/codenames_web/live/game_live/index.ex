defmodule CodenamesWeb.GameLive.Index do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.{Card, Team}
  alias CodenamesWeb.{Endpoint, Presence}
  alias Codenames.Board
  alias Phoenix.Socket.Broadcast
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    PubSub.subscribe(Codenames.PubSub, "game_room")
    Presence.track(self(), "game_room", user.email, user)
    Endpoint.subscribe("game_room")

    socket = assign(socket, :user_emails, fetch_current_emails())
    socket = assign(socket, :board, Board.build_game_board())

    {:ok, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: payload, topic: _topic}, socket) do
    _joins = Map.get(payload, :joins)
    _leaves = Map.get(payload, :leaves)

    {:noreply, reload_users(socket)}
  end

  def reload_users(socket) do
    users =
      Presence.list("game_room")
      |> Enum.map(fn {_user_id, data} ->
        List.first(data[:metas])
      end)

    socket
    |> assign(:users, users)
  end

  defp fetch_current_emails() do
    Presence.list("game_room")
    |> Enum.map(fn {email, _meta} -> email end)
  end
end
