defmodule Codenames.Server.Server do
  @moduledoc """
  Server context
  """
  use GenServer

  alias Codenames.Server.Match
  alias Codenames.Server.Board
  alias Codenames.GameRegistry

  def start_link([room_id, email, %Board{} = board]) do
    initial_match = Match.new(room_id, email, board)

    GenServer.start_link(__MODULE__, initial_match, name: via_tuple(room_id))
  end

  def init(match), do: {:ok, match}

  def handle_call({:join, email}, _from, match) do
    if Board.already_on_match?(match.board, email) do
      {:reply, match, match}
    else
      match = Match.join(match, email)
      {:reply, match, match}
    end
  end

  def handle_call({:start_game, email}, _from, match) do
    match = Match.start_match(match, email)
    {:reply, match, match}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def join(room_id, email) do
    GenServer.call(via_tuple(room_id), {:join, email})
  end

  def start_game(room_id, email) do
    GenServer.call(via_tuple(room_id), {:start_game, email})
  end

  def get_state(room_id) do
    GenServer.call(via_tuple(room_id), :get_state)
  end

  def via_tuple(id) do
    {:via, Registry, {GameRegistry, id}}
  end

  def server_exists?(id) do
    case Registry.lookup(GameRegistry, id) do
      [] -> false
      _ -> true
    end
  end

  def list_all_game_servers do
    Registry.keys(GameRegistry, self())
  end
end
