defmodule Hexagon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start default Finch HTTP pool
      {Finch, name: Hexagon.FinchPool, pools: %{:default => [size: 32]}},
      # Start the local store. A no-op if not configured
      Hexagon.Extensions.Plug.LocalStore,
      # Start the Ecto repository
      Hexagon.Repo,
      # Start the Telemetry supervisor
      HexagonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hexagon.PubSub},
      # Start the Endpoint (http/https)
      HexagonWeb.Endpoint
      # Start a worker by calling: Hexagon.Worker.start_link(arg)
      # {Hexagon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hexagon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HexagonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
