defmodule ElevatorSimulator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElevatorSimulatorWeb.Telemetry,
      ElevatorSimulator.Repo,
      {DNSCluster, query: Application.get_env(:elevator_simulator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElevatorSimulator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElevatorSimulator.Finch},
      # Start a worker by calling: ElevatorSimulator.Worker.start_link(arg)
      # {ElevatorSimulator.Worker, arg},
      # Start to serve requests, typically the last entry
      ElevatorSimulatorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElevatorSimulator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElevatorSimulatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
