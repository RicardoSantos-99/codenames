defmodule Codenames.Server.Server do
  @moduledoc """
  Server context
  """
  use GenServer

  alias Codenames.Games.Board.BoardSchema
  alias Codenames.Games.Board
  alias Codenames.Games.GameSchema
  alias Codenames.Game
  alias Codenames.GameRegistry

  def start_link([room_id, email, %BoardSchema{} = board]) do
    game = %GameSchema{
      room_id: room_id,
      admin: email,
      board: board
    }

    GenServer.start_link(__MODULE__, game, name: via_tuple(room_id))
  end

  def init(game), do: {:ok, game}

  def handle_call({:join, email}, _from, game) do
    if Board.already_on_match?(game.board, email) do
      {:reply, game, game}
    else
      game = Game.join(game, email)
      {:reply, game, game}
    end
  end

  def handle_call({:start_game, email}, _from, game) do
    game = Game.start(game, email)
    {:reply, game, game}
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
