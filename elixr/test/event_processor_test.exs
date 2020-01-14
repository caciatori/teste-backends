defmodule EventProcessorTest do
  use ExUnit.Case
  alias Elixr.FileReader
  alias Elixr.EventProcessor

  @model_one FileReader.read_model_one()
  @model_two FileReader.read_model_two()

  test "Read an invalid parameter and return a nil value" do
    assert EventProcessor.process("") == nil
    assert EventProcessor.process(nil) == nil
  end

  test "total_of_events is equals ao length of events" do
    %{events: events, total_of_events: total_of_events} = EventProcessor.process(@model_one)
    assert total_of_events == length(events)
  end
end
