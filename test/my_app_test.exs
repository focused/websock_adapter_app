defmodule MyAppTest do
  use ExUnit.Case

  alias MyApp.Router
  alias MyApp.WSClient
  alias MyApp.WSHandler

  @host "localhost:4000"
  @path "/ws"
  # @ws_endpoint "ws://" <> @host <> @path

  setup :init_conn

  describe "HTTP" do
    test "upgrades connection", %{conn: conn} do
      conn = perform_upgrade_request(conn)

      assert [{:websocket, {WSHandler, _state, _opts}}] = Plug.Test.sent_upgrades(conn)
    end

    defp init_conn(_ctx) do
      conn = Plug.Test.conn(:get, @path)

      # set the host header, otherwise will raise:
      # ** (Plug.Conn.WrapperError) ** (WebSockAdapter.UpgradeError) 'host' header is absent
      conn =
        %Plug.Conn{conn | req_headers: [{"host", @host} | conn.req_headers]}
        |> Plug.Conn.put_req_header("upgrade", "websocket")
        |> Plug.Conn.put_req_header("connection", "Upgrade")
        |> Plug.Conn.put_req_header("sec-websocket-key", "dGhlIHNhbXBsZSBub25jZQ==")
        |> Plug.Conn.put_req_header("sec-websocket-version", "13")

      %{conn: conn}
    end
  end

  describe "WS" do
    test "" do
      {:ok, pid} = WSClient.start_link(%WSHandler.State{})

      WSClient.echo(pid, "TEST MSG")

      :timer.sleep(10)
    end
  end

  defp perform_upgrade_request(conn), do: Router.call(conn, Router.init([]))
end
