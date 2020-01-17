defmodule BcrediApp.ProponentTest do
  use ExUnit.Case

  import Mox

  alias BcrediApp.{FileReader, Processor, Proponent, Queue}

  @input_one Processor.execute(FileReader.read_model_one())

  test "proponents_are_valid/2 should return true with a valid model " do
    %{events: events} = @input_one

    BcrediApp.ClientMock
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)

    assert true ==
             Proponent.valid_proponents?(%{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })
  end

  defp build_queue_model(events) do
    result = %Queue{}

    %{
      result
      | proposals: Enum.filter(events, &(&1.event_schema == :proposal)),
        proponents: Enum.filter(events, &(&1.event_schema == :proponent)),
        warranties: Enum.filter(events, &(&1.event_schema == :warranty))
    }
  end
end
