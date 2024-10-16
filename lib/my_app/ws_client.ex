defmodule MyApp.WSClient do
  use WebSockex

  @endpoint "ws://localhost:4000/ws"

  def start_link(state) do
    WebSockex.start_link(@endpoint, __MODULE__, state, name: __MODULE__)
  end

  @spec echo(pid, String.t()) :: :ok
  def echo(client, message) do
    IO.puts("Sending message: #{message}")
    WebSockex.send_frame(client, {:text, message})
  end

  @impl true
  def handle_frame({type, msg}, state) do
    IO.puts("Received Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
    {:ok, state}
  end

  @impl true
  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end
end
