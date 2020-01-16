defmodule QueueTest do
  use ExUnit.Case
  alias BcrediApp.{Event, Queue}

  test "action/4 process all events and put them to the state" do
    created_proposal = %Event{event_id: "1", proposal_id: "1"}
    added_proponent = %Event{event_id: "2", proponent_id: "1"}
    added_warranty = %Event{event_id: "3", warranty_id: "1"}

    result = Queue.action(:created, created_proposal, :proposals, %Queue{})
    result = Queue.action(:added, added_proponent, :proponents, result)
    result = Queue.action(:added, added_warranty, :warranties, result)

    assert length(result.proponents) == 1
    assert length(result.proposals) == 1
    assert length(result.warranties) == 1
    assert length(result.events) == 3
  end

  test "action/4 should ignore duplicated events" do
    created_proposal = %Event{event_id: "1", proposal_id: "1"}

    result = %Queue{}
    result = Queue.action(:created, created_proposal, :proposals, result)
    result = Queue.action(:created, created_proposal, :proposals, result)
    result = Queue.action(:created, created_proposal, :proposals, result)
    result = Queue.action(:created, created_proposal, :proposals, result)

    assert length(result.proposals) == 1
    assert length(result.events) == 1
  end

  test "action/4 shoud remove an element from list" do
    created_proposal_1 = %Event{event_id: "1", proposal_id: "1"}
    created_proposal_2 = %Event{event_id: "2", proposal_id: "2"}

    result = %Queue{}
    result = Queue.action(:created, created_proposal_1, :proposals, result)
    result = Queue.action(:created, created_proposal_2, :proposals, result)
    result = Queue.action(:deleted, created_proposal_1, :proposals, result)

    assert length(result.proposals) == 1
    assert length(result.events) == 3

    result = Queue.action(:removed, created_proposal_2, :proposals, result)

    assert length(result.proposals) == 0
    assert length(result.events) == 4
  end

  test "action/4 shoud ignore and not raise exception when try remove an element that already removed" do
    created_proposal_1 = %Event{event_id: "1", warranty_id: "1"}
    %{event_id: event_id_1} = created_proposal_1

    result = %Queue{}
    result = %{result | events: [event_id_1]}

    result = Queue.action(:deleted, created_proposal_1, :warranties, result)

    assert length(result.proposals) == 0
  end

  test "action/4 change name of proponent" do
    added_proponent = %Event{event_id: "2", proponent_id: "1", proponent_name: "José"}
    updated_proponent = %Event{event_id: "4", proponent_id: "1", proponent_name: "João"}
    %{event_id: event_id} = updated_proponent

    result = %Queue{}
    result = Queue.action(:added, added_proponent, :proponents, result)
    result = Queue.action(:updated, updated_proponent, :proponents, result)

    proponent = Enum.find(result.proponents, &(&1.event_id == event_id))

    assert proponent.proponent_name == "João"
    assert length(result.events) == 2
    assert length(result.proponents) == 1
  end
end
