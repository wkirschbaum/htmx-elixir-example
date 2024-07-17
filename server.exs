Mix.install([
  {:req, "~> 0.5.2"},
  {:plug, "~> 1.16"},
  {:bandit, "~> 1.0"},
  {:jason, "~> 1.4"}
])

defmodule Server do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, {:json, json_decoder: Jason}],
    pass: ["*/*"]
  )

  get "/" do
    body = File.read!("www/index.html")

    send_resp(conn, 200, body)
  end

  get "/messages" do
    send_resp(conn, 200, "world")
  end

  put "/messages" do
    IO.puts("called put messages.")

    send_resp(conn, 200, "Success!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end

Bandit.start_link(plug: Server)

IO.gets("Press a key to stop the server")
