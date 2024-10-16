defmodule MyApp.WSHandler do
  @behaviour WebSock

  defmodule State do
    defstruct [:x, :y]
  end

  def init(%State{} = state) do
    IO.inspect(state, label: "-------------------------------------------------------------")

    erroneous_fun(%{})

    {:ok, state}
  end

  def handle_in({message, opcode: _opcode}, state) do
    {:push, {:text, "=> RESPONSE: #{message}"}, state}
  end

  def handle_info(info, state) do
    IO.inspect(info)
    {:ok, state}
  end

  def terminate(reason, _state) do
    IO.inspect(reason)
    :ok
  end

  defp erroneous_fun(%{}) do
    raise "Custom Error"
  end

  # defp erroneous_fun(%{a: 1}) do
  #   :ok
  # end
end
