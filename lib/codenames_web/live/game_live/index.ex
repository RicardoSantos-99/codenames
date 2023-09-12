defmodule CodenamesWeb.GameLive.Index do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.{Card, Team}
  alias CodenamesWeb.{Presence}
  alias Codenames.Game.{Board, Server, Match}
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

    board = Board.join_spymaster(socket.assigns.board, user.email, String.to_atom(team))
    update_board("game_room:1", board)

    {:noreply, assign(socket, :board, board)}
  end

  @impl true
  def handle_event("operative", %{"team" => team}, socket) do
    user = socket.assigns.current_user

    board = Board.join_operative(socket.assigns.board, user.email, String.to_atom(team))

    update_board("game_room:1", board)
    {:noreply, socket |> assign(:board, board)}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: _payload, topic: _topic}, socket) do
    users =
      Presence.list("game_room:#{1}")
      |> Enum.map(fn {_user_id, data} -> List.first(data[:metas]).email end)

    {:noreply, socket |> assign(:user_emails, users)}
  end

  def handle_info({:update_board, board}, socket) do
    {:noreply, socket |> assign(:board, board)}
  end

  def update_board(channel, board) do
    PubSub.broadcast(Codenames.PubSub, channel, {:update_board, board})
  end

  defp setup_board_and_server(room_id, user) do
    case Server.server_exists?(room_id) do
      true ->
        %Match{board: board} = Server.join(room_id, user.email)
        update_board("game_room:1", board)
        board

      false ->
        %Board{} = board = Board.build_game_board(user)
        Server.start_link(room_id, user.email, board)
        board
    end
  end
end
