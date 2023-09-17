defmodule Codenames.Games.Team do
  @moduledoc """
  Team context
  """
  def add_spymaster(team, spymaster) do
    %{team | spymaster: spymaster}
  end

  def remove_spymaster(team) do
    %{team | spymaster: nil}
  end

  def add_player(team, player) do
    %{team | players: [player | team.players]}
  end

  def remove_player(team, player) do
    %{team | players: List.delete(team.players, player)}
  end

  def player_is_spymaster?(team, player) do
    team.spymaster == player
  end

  def already_in_team?(team, player) do
    Enum.member?(team.players, player)
  end
end
