defmodule Metrics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  import Telemetry.Metrics

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # Metrics.Repo,
      # Start the endpoint when the application starts
      MetricsWeb.Endpoint,
      # Starts a worker by calling: Metrics.Worker.start_link(arg)
      # {Metrics.Worker, arg},
      {Telemetry.Metrics.ConsoleReporter, [metrics: metrics()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Metrics.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MetricsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp metrics do
    [
      counter("woot.stop.duration",
        tags: [:status, :hostname, :keys],
        tag_values: &conn_metric_value/1
      )
      # counter("vm.memory.total")
    ]
  end

  def conn_metric_value(conn) do
    %{status: conn.conn.status, hostname: :inet.gethostname() |> elem(1), keys: Map.keys(conn)}
  end
end
