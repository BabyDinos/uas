defmodule Uas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UasWeb.Telemetry,
      # Start the Ecto repository
      Uas.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Uas.PubSub},
      # Start Finch
      {Finch, name: Uas.Finch},
      # Start the Endpoint (http/https)
      UasWeb.Endpoint
      # Start a worker by calling: Uas.Worker.start_link(arg)
      # {Uas.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
