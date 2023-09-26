defmodule Codenames.Server.Manager do
  @moduledoc """
  Manager context
  """
  use DynamicSupervisor

  alias Codenames.Server.Server

  def start_link do
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def start_server(room_id, user) do
    existing_process(room_id) || start(room_id, user)
  end

  defp existing_process(room_id) do
    Server.server_exists?(room_id)
  end

  defp start(room_id, user) do
    spec = {Server, [room_id, user]}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def count_game_servers do
    DynamicSupervisor.count_children(__MODULE__)
  end

  def which_game_servers do
    DynamicSupervisor.which_children(__MODULE__)
  end
end
