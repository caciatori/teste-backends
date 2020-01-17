defmodule BcrediApp.Queue do
  @moduledoc """
  Module that manipulate state of the queue
  """
  defstruct(
    events: [],
    proponents: [],
    proposals: [],
    warranties: []
  )

  def initialize do
    %BcrediApp.Queue{}
  end

  def action(action, event = %{event_id: event_id}, property, state) do
    perfom_action(action, event, property, state, Enum.member?(state.events, event_id))
  end

  defp perfom_action(action, _, _, state, true) when action in [:added, :created] do
    state
  end

  defp perfom_action(action, event = %{event_id: event_id}, property, state, false)
       when action in [:added, :created] do
    %{
      current_prop_state: current_prop_state,
      current_events: current_events
    } = get_initial_state(state, property)

    state
    |> Map.put(property, [event | current_prop_state])
    |> Map.put(:events, [event_id | current_events])
  end

  defp perfom_action(action, %{event_id: event_id}, property, state, true)
       when action in [:deleted, :removed] do
    %{
      current_prop_state: current_prop_state,
      current_events: current_events
    } = get_initial_state(state, property)

    exists = event_exists?(current_prop_state, event_id)

    state
    |> Map.put(property, remove_event(current_prop_state, event_id, exists))
    |> Map.put(:events, [event_id | current_events])
  end

  defp perfom_action(:updated, event = %{event_id: event_id}, property, state, false) do
    %{
      current_prop_state: current_prop_state,
      current_events: current_events
    } = get_initial_state(state, property)

    %{event_id: old_event_id} = find_event(current_prop_state, property, event)

    exists = event_exists?(current_prop_state, old_event_id)

    current_prop_state = remove_event(current_prop_state, old_event_id, exists)
    current_prop_state = [event | current_prop_state]

    state
    |> Map.put(property, current_prop_state)
    |> Map.put(:events, [event_id | current_events])
  end

  defp get_initial_state(state, property) do
    current_prop_state = Map.get(state, property, [])
    current_events = Map.get(state, :events, [])

    %{current_prop_state: current_prop_state, current_events: current_events}
  end

  defp event_exists?(state, event_id) do
    Enum.any?(state, &(&1.event_id == event_id))
  end

  defp remove_event(event_list, event_id, _exits = true) do
    Enum.filter(event_list, &(&1.event_id != event_id))
  end

  defp remove_event(event_list, _event_id, _exits = false) do
    event_list
  end

  def find_event(event_list, property, event) do
    cond do
      :proposals == property ->
        %{proposal_id: proposal_id} = event
        Enum.find(event_list, &(&1.proposal_id == proposal_id))

      :proponents == property ->
        %{proponent_id: proponent_id} = event
        Enum.find(event_list, &(&1.proponent_id == proponent_id))

      :warranties == property ->
        %{warranty_id: warranty_id} = event
        Enum.find(event_list, &(&1.warranty_id == warranty_id))

      true ->
        event
    end
  end
end
