defmodule BcrediApp.WarrantyTest do
  use ExUnit.Case

  import Mox

  alias BcrediApp.{FileReader, Processor, Queue, Warranty}

  @input_one Processor.execute(FileReader.read_model_one())
  @input_two Processor.execute(FileReader.read_model_two())

  test "warranties_its_valid/2 should return true with a valid model " do
    %{events: events} = @input_one

    BcrediApp.ClientMock
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)

    assert true ==
             Warranty.warranties_its_valid?(%{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

  end

  test "warranties_its_valid/2 should return true with an invalid model " do
    %{events: events} = Processor.execute(FileReader.read("invalid_warranty.txt"))

    BcrediApp.ClientMock
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)
    |> expect(:read_messages, fn -> build_queue_model(events) end)

    assert false ==
             Warranty.warranties_its_valid?(%{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert false ==
             Warranty.warranties_its_valid?(%{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })

    assert false ==
             Warranty.warranties_its_valid?(%{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4i"
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
