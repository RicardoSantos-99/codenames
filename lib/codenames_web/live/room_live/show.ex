defmodule CodenamesWeb.RoomLive.Show do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.{Card, Team}
  alias CodenamesWeb.RoomLive.FormComponent

  alias Codenames.Rooms
  alias CodenamesWeb.Presence
  alias Codenames.Server.{Manager, Server}
  alias Phoenix.PubSub
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    user = socket.assigns.current_user
    topic = "game_room:#{room_id}"

    game = start_game(topic, user)

    PubSub.subscribe(Codenames.PubSub, topic)
    Presence.track(self(), topic, user.username, user)

    socket =
      socket
      |> assign(:user_emails, [])
      |> assign(:game, game)
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
    %{current_user: user, topic: topic} = socket.assigns

    game = Server.join_spymaster(topic, user.username, String.to_atom(team))
    update_board(topic, game.board)

    {:noreply, socket |> assign(:game, game)}
  end

  @impl true
  def handle_event("operative", %{"team" => team}, socket) do
    %{current_user: user, topic: topic} = socket.assigns

    game = Server.join_operative(topic, user.username, String.to_atom(team))

    update_board(topic, game.board)
    {:noreply, socket |> assign(:game, game)}
  end

  def handle_event("start", _params, socket) do
    Server.start_game(socket.assigns.topic, socket.assigns.current_user.email)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: _payload, topic: _topic}, socket) do
    users =
      Presence.list(socket.assigns.topic)
      |> Enum.map(fn {_user_id, data} -> List.first(data[:metas]).username end)

    {:noreply, socket |> assign(:user_emails, users)}
  end

  def handle_info({:update_board, board}, socket) do
    game = %{socket.assigns.game | board: board}
    {:noreply, socket |> assign(:game, game)}
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
        game = Server.join(room_id, user.username)

        update_board(room_id, game.board)
        game

      false ->
        Manager.start_server(room_id, user.username)
        Server.get_state(room_id)
    end
  end

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"
end
