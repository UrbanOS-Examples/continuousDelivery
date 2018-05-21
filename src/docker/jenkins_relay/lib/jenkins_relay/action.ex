defmodule JenkinsRelay.Action do
  def handle(conn, payload) do
    "http://#{System.get_env("JENKINS_HOST")}:#{System.get_env("JENKINS_PORT")}/github-webhook/"
    |> HTTPoison.post(payload, conn.req_headers)
  end
end
