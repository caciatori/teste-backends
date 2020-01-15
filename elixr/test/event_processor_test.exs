defmodule EventProcessorTest do
  use ExUnit.Case
  alias Elixr.FileReader
  alias Elixr.EventProcessor

  @model_one FileReader.read_model_one()

  test "Read an invalid parameter and return a empty list" do
    assert EventProcessor.process(nil) == []
  end

  test "total_of_events is equals ao length of events" do
    %{events: events, total_of_events: total_of_events} = EventProcessor.process(@model_one)
    assert total_of_events == length(events)
  end
end
