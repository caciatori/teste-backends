defmodule BcrediApp.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :bapp)
  end

  def init(_args) do
    {:ok, BcrediApp.Queue.initialize()}
  end

  def handle_call({:created_proposal, event}, _from, state) do
    perfom_action(:created, event, :proposals, state)
  end

  def handle_call({:updated_proposal, event}, _from, state) do
    perfom_action(:updated, event, :proposals, state)
  end

  def handle_call({:deleted_proposal, event}, _from, state) do
    perfom_action(:deleted, event, :proposals, state)
  end

  def handle_call({:added_proponent, event}, _from, state) do
    perfom_action(:added, event, :proponents, state)
  end

  def handle_call({:updated_proponent, event}, _from, state) do
    perfom_action(:updated, event, :proponents, state)
  end

  def handle_call({:removed_proponent, event}, _from, state) do
    perfom_action(:removed, event, :proponents, state)
  end

  def handle_call({:added_warranty, event}, _from, state) do
    perfom_action(:added, event, :warranties, state)
  end

  def handle_call({:removed_warranty, event}, _from, state) do
    perfom_action(:removed, event, :warranties, state)
  end

  def handle_call({:updated_warranty, event}, _from, state) do
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
