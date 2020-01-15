defmodule Elixr.WarrantyTest do
  use ExUnit.Case
  alias Elixr.{EventProcessor, FileReader, Warranty}

  @input_one EventProcessor.process(FileReader.read_model_one())
  @input_two EventProcessor.process(FileReader.read_model_two())

  test "warranties_its_valid/2 should return true with a valid model " do
    %{events: events_one} = @input_one
    %{events: events_two} = @input_two

    assert true ==
             Warranty.warranties_its_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert true ==
             Warranty.warranties_its_valid?(events_two, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })
  end

  test "warranties_its_valid/2 should return true with an invalid model " do
    %{events: events_one} = EventProcessor.process(FileReader.read("invalid_warranty.txt"))

    assert false ==
             Warranty.warranties_its_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert false ==
             Warranty.warranties_its_valid?(events_one, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })

    assert false ==
             Warranty.warranties_its_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4i"
             })
  end
end
