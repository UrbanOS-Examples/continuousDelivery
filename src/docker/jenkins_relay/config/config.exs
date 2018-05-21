use Mix.Config

config :gh_webhook_plug,
  path: "/github-webhook/",
  action: {JenkinsRelay.Action, :handle}
