defmodule JenkinsRelayTest do
  use ExUnit.Case
  alias FakeServer.HTTP.Response
  import FakeServer

  def setup_environment(address) do
    [host, port] = String.split(address, ":")
    System.put_env("JENKINS_HOST", host)
    System.put_env("JENKINS_PORT", port)
    System.put_env("GH_WEBHOOK_SECRET", "peanuts")
  end

  def create_signature(secret, payload) do
    "sha1=" <> (:crypto.hmac(:sha, secret, payload) |> Base.encode16(case: :lower))
  end

  test_with_server "passes body through to jenkins url when secret matches" do
    {:ok, pid} = Agent.start_link(fn -> [] end)

    route("/github-webhook/", fn request ->
      Agent.update(pid, fn _ -> request end)
      Response.ok()
    end)

    setup_environment(FakeServer.address())
    signature = create_signature("peanuts", "payload")

    HTTPoison.post("http://localhost:8080/github-webhook/", "payload", [
      {"X-Hub-Signature", signature}
    ])

    request = Agent.get(pid, fn req -> req end)

    assert FakeServer.hits() == 1
    assert request.method == "POST"
    assert Map.get(request.headers, "x-hub-signature") == signature
    assert request.body == "payload"
  end

  test_with_server "does not call jenkins url when secret is incorrect" do
    route("/github-webhook/", Response.ok())

    setup_environment(FakeServer.address())
    signature = create_signature("wrong secret", "payload")

    HTTPoison.post("http://localhost:8080/github-webhook/", "payload", [
      {"X-Hub-Signature", signature}
    ])

    assert FakeServer.hits() == 0
  end

  test_with_server "does not call jenkins url when not calling the webhook path" do
    route("/github-webhook/", Response.ok())

    setup_environment(FakeServer.address())
    signature = create_signature("peanuts", "payload")

    {:ok, response} =
      HTTPoison.post("http://localhost:8080/not-a-real-webhook/", "payload", [
        {"X-Hub-Signature", signature}
      ])

    assert FakeServer.hits() == 0
    assert response.status_code == 404
  end
end
