defmodule Codenames.Server.Server do
  @moduledoc """
  Server context
  """
  use GenServer

  alias Codenames.Game
  alias Codenames.GameRegistry
  alias Codenames.Games.{Board, GameSchema}

  def start_link([room_id, user]) do
    game = %GameSchema{
      room_id: room_id,
      admin_id: user.id,
      board: Board.build_game_board()
    }

    GenServer.start_link(__MODULE__, game, name: via_tuple(room_id))
  end

  def init(game), do: {:ok, game}

  def handle_call({:start_game, username}, _from, game) do
    game = Game.start(game, username)

    {:reply, game, game}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:join_spymaster, username, team_color}, _from, game) do
    game = %{game | board: Board.join_spymaster(game.board, username, team_color)}

    {:reply, game, game}
  end

  def handle_call({:join_operative, username, team_color}, _from, game) do
    game = %{game | board: Board.join_operative(game.board, username, team_color)}

    {:reply, game, game}
  end

  def join_spymaster(room_id, username, team_color) do
    GenServer.call(via_tuple(room_id), {:join_spymaster, username, team_color})
  end

  def join_operative(room_id, username, team_color) do
    GenServer.call(via_tuple(room_id), {:join_operative, username, team_color})
  end

  def start_game(room_id, username) do
    GenServer.call(via_tuple(room_id), {:start_game, username})
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
