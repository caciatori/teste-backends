defmodule BcrediApp.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_args) do
    {:ok, BcrediApp.Queue.initialize()}
  end

  def handle_call({:create_proposal, event}, _from, state) do
    perfom_action(:added, event, :proposals, state)
  end

  def handle_call({:update_proposal, event}, _from, state) do
    perfom_action(:updated, event, :proposals, state)
  end

  def handle_call({:remove_proposal, event}, _from, state) do
    perfom_action(:deleted, event, :proposals, state)
  end

  def handle_call({:add_proponent, event}, _from, state) do
    perfom_action(:added, event, :proponents, state)
  end

  def handle_call({:update_proponent, event}, _from, state) do
    perfom_action(:updated, event, :proponents, state)
  end

  def handle_call({:remove_proponent, event}, _from, state) do
    perfom_action(:removed, event, :proponents, state)
  end

  def handle_call({:add_warranty, event}, _from, state) do
    perfom_action(:added, event, :warranties, state)
  end

  def handle_call({:remove_warranty, event}, _from, state) do
    perfom_action(:removed, event, :warranties, state)
  end

  def handle_call({:update_warranty, event}, _from, state) do
    perfom_action(:updated, event, :warranties, state)
  end

  def handle_call({:events}, _from, state) do
    {:reply, state, state}
  end

  defp perfom_action(action, event, property, state) do
    new_state = BcrediApp.Queue.action(action, event, property, state)
    {:reply, new_state, new_state}
  end
end
