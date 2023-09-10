defmodule Codenames.Game.Server do
  use GenServer

  alias Codenames.Game.Match

  def start_link(room_id, email, board) do
    initial_match = Match.new(room_id, email, board)

    GenServer.start_link(__MODULE__, initial_match, name: via_tuple(room_id))
  end

  def init(match), do: {:ok, match}

  def handle_call({:join, email}, _from, match) do
    {:reply, Match.add_player(match, email), Match.add_player(match, email)}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def join(room_id, email) do
    GenServer.call(via_tuple(room_id), {:join, email})
  end

  def get_state(room_id) do
    GenServer.call(via_tuple(room_id), :get_state)
  end

  def via_tuple(id) do
    {:via, Registry, {Codenames.GameRegistry, id}}
  end

  def server_exists?(id) do
    case Registry.lookup(Codenames.GameRegistry, id) do
      [] -> false
      _ -> true
    end
  end
end
