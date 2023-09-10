defmodule CodenamesWeb.GameLive.Index do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.{Card, Team}
  alias CodenamesWeb.{Presence}
  alias Codenames.Board
  alias Phoenix.Socket.Broadcast
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    PubSub.subscribe(Codenames.PubSub, "game_room")
    Presence.track(self(), "game_room", user.email, user)

    socket = assign(socket, :user_emails, [])
    socket = assign(socket, :board, Board.build_game_board())

    {:ok, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: _payload, topic: _topic}, socket) do
    users =
      Presence.list("game_room")
      |> Enum.map(fn {_user_id, data} -> List.first(data[:metas]).email end)

    {:noreply, socket |> assign(:user_emails, users)}
  end
end
