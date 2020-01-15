defmodule BcrediApp.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_args) do
    {:ok, BcrediApp.Queue.initialize()}
  end

  def handle_call({:add_proponent, proponent}, _from, state) do
    new_state = BcrediApp.Queue.action(:add_proponent, proponent, state)
    IO.inspect(new_state)
    {:reply, new_state, state}
  end
end
