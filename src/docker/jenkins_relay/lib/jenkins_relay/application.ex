defmodule JenkinsRelay.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: JenkinsRelay, options: [port: 8080])
    ]

    opts = [strategy: :one_for_one, name: JenkinsRelay.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
