defmodule CodenamesWeb.GameLive.Index do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.{Card, Team}
  alias CodenamesWeb.{Presence}
  alias Codenames.Game.{Server, Match}
  alias Phoenix.Socket.Broadcast
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    room_id = ~c"1"

    board = setup_board_and_server(room_id, user)

    PubSub.subscribe(Codenames.PubSub, "game_room:#{room_id}")
    Presence.track(self(), "game_room:#{room_id}", user.email, user)

    socket =
      socket
      |> assign(:user_emails, [])
      |> assign(:board, board)

    {:ok, socket}
  end

  @impl true
  def handle_event("spymaster", %{"team" => team}, socket) do
    user = socket.assigns.current_user

    board = Match.join_spymaster(socket.assigns.board, user.email, team)

    # TODO: Update the board in the Presence

    {:noreply, assign(socket, :board, board)}
  end

  @impl true
  def handle_event("operative", %{"team" => team}, socket) do
    user = socket.assigns.current_user

    case Match.join_operative(socket.assigns.board, user.email, team) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, message)}

      {:ok, board} ->
        {:noreply, socket |> assign(:board, board)}
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: _payload, topic: _topic}, socket) do
    users =
      Presence.list("game_room:#{1}")
      |> Enum.map(fn {_user_id, data} -> List.first(data[:metas]).email end)

    {:noreply, socket |> assign(:user_emails, users)}
  end

  defp setup_board_and_server(room_id, user) do
    if Server.server_exists?(room_id) do
      server = Server.join(room_id, user.email)
      server.board
    else
      board = Match.build_game_board(user)
      Server.start_link(room_id, user.email, board)
      board
    end
  end
end
