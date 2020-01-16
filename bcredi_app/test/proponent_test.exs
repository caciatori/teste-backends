defmodule BcrediApp.ProponentTest do
  use ExUnit.Case
  alias BcrediApp.{Processor, FileReader, Proponent}

  @input_one Processor.execute(FileReader.read_model_one())
  @input_two Processor.execute(FileReader.read_model_two())

  test "proponents_are_valid/2 should return true with a valid model " do
    %{events: events_one} = @input_one
    %{events: events_two} = @input_two

    assert true ==
             Proponent.proponents_are_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert true ==
             Proponent.proponents_are_valid?(events_two, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })
  end
end
