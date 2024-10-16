defmodule MyApp.Router do
  use Plug.Router
  alias MyApp.WSHandler

  plug(:match)
  plug(:dispatch)

  @ws_idle_timeout 120_000

  get "/ws" do
    conn
    |> WebSockAdapter.upgrade(WSHandler, %WSHandler.State{}, timeout: @ws_idle_timeout)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
