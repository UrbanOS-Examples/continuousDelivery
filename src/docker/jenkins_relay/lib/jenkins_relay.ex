defmodule JenkinsRelay do
  use Plug.Router

  plug(Plug.Logger)
  plug(GhWebhookPlug)
  plug(:match)
  plug(:dispatch)

  match _ do
    send_resp(conn, 404, "oops!")
  end
end
