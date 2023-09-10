defmodule Codenames.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CodenamesWeb.Telemetry,
      # Start the Ecto repository
      Codenames.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Codenames.PubSub},
      # Start Finch
      {Finch, name: Codenames.Finch},
      # Start the Endpoint (http/https)
      CodenamesWeb.Endpoint
      # Start a worker by calling: Codenames.Worker.start_link(arg)
      # {Codenames.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Codenames.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CodenamesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
