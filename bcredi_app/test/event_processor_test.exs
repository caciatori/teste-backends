defmodule ProcessorTest do
  use ExUnit.Case
  alias BcrediApp.FileReader
  alias BcrediApp.Processor

  @model_one FileReader.read_model_one()

  test "Read an invalid parameter and return a empty list" do
    assert Processor.execute(nil) == []
  end

  test "total_of_events is equals ao length of events" do
    %{events: events, total_of_events: total_of_events} = Processor.execute(@model_one)
    assert total_of_events == length(events)
  end
end
