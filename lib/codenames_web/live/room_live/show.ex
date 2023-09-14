defmodule CodenamesWeb.RoomLive.Show do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.{Card, Team}

  alias CodenamesWeb.Presence
  alias Codenames.Game.{Board, Manager, Match, Server}
  alias Codenames.Rooms
  alias Phoenix.PubSub
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    user = socket.assigns.current_user
    topic = "game_room:#{room_id}"

    board = Board.build_game_board()

    PubSub.subscribe(Codenames.PubSub, topic)
    Presence.track(self(), topic, user.email, user)

    socket =
      socket
      |> assign(:user_emails, [])
      |> assign(:board, board)
      |> assign(:topic, topic)
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:room, Rooms.get_room!(room_id))

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:room, Rooms.get_room!(id))}
  end

  @impl true
  def handle_event("spymaster", %{"team" => team}, socket) do
    user = socket.assigns.current_user

    board = Board.join_spymaster(socket.assigns.board, user.email, String.to_atom(team))
    update_board(socket.assigns.topic, board)

    {:noreply, socket |> assign(:board, board)}
  end

  @impl true
  def handle_event("operative", %{"team" => team}, socket) do
    user = socket.assigns.current_user

    board = Board.join_operative(socket.assigns.board, user.email, String.to_atom(team))

    update_board(socket.assigns.topic, board)
    {:noreply, socket |> assign(:board, board)}
  end

  def handle_event("start", _params, socket) do
    board = start_game(socket.assigns.topic, socket.assigns.current_user)
    update_board(socket.assigns.topic, board)
    {:noreply, socket |> assign(:board, board)}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: _payload, topic: _topic}, socket) do
    users =
      Presence.list(socket.assigns.topic)
      |> Enum.map(fn {_user_id, data} -> List.first(data[:metas]).email end)

    {:noreply, socket |> assign(:user_emails, users)}
  end

  def handle_info({:update_board, board}, socket) do
    {:noreply, socket |> assign(:board, board)}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  def update_board(topic, board) do
    PubSub.broadcast(Codenames.PubSub, topic, {:update_board, board})
  end

  def start_game(room_id, user) do
    case Server.server_exists?(room_id) do
      true ->
        %Match{board: board} = Server.join(room_id, user.email)
        update_board(room_id, board)
        board

      false ->
        %Board{} = board = Board.build_game_board()

        Manager.start_match(room_id, user.email, board)
        board
    end
  end

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"
end
