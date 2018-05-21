defmodule JenkinsRelay.MixProject do
  use Mix.Project

  def project do
    [
      app: :jenkins_relay,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {JenkinsRelay.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.5"},
      {:gh_webhook_plug,
       git: "https://github.com/SmartColumbusOS/gh_webhook_plug.git", branch: "master"},
      {:httpoison, "~> 1.1"},
      {:fake_server, "~> 1.4", only: :test},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false}
    ]
  end
end
