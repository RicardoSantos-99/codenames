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

    Presence.track(self(), topic, user.id, %{
      name: user.username,
      joined_at: :os.system_time(:seconds)
    })

    socket =
      socket
      |> assign(:game, game)
      |> assign(:topic, topic)
      |> assign(:current_user, user)
      |> assign(:users, %{})
      |> handle_joins(Presence.list(topic))

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
    %{topic: topic, current_user: user} = socket.assigns

    game = Server.start_game(topic, user.username)

    update_board(topic, game.board)

    {:noreply, socket |> assign(:game, game)}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)
    }
  end

  def handle_info({:update_board, board}, socket) do
    game = %{socket.assigns.game | board: board}
    {:noreply, socket |> assign(:game, game)}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
  end

  def update_board(topic, board) do
    PubSub.broadcast(Codenames.PubSub, topic, {:update_board, board})
  end

  def start_game(room_id, user) do
    case Server.server_exists?(room_id) do
      true ->
        game = Server.get_state(room_id)

        update_board(room_id, game.board)
        game

      false ->
        Manager.start_server(room_id, user)
        Server.get_state(room_id)
    end
  end

  def leave_game([], socket), do: socket

  def leave_game(users, socket) when socket.assigns.game.status == "waiting" do
    users
    |> Enum.each(fn _username ->
      nil
      # game = Server.leave(socket.assigns.topic, username)

      # update_board(socket.assigns.topic, game.board)
    end)
  end

  def leave_game(_, socket), do: socket

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"
end
