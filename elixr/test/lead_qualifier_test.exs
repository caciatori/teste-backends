defmodule Elixr.LeadQualifierTest do
  use ExUnit.Case
  alias Elixr.{EventProcessor, FileReader, LeadQualifier}

  @input_one EventProcessor.process(FileReader.read_model_one())
  @input_two EventProcessor.process(FileReader.read_model_two())

  # test "Should return two valid proposals" do
  #   %{events: events, total_of_events: total_of_events} = LeadQualifier.qualify(@input_one)
  #   [h | t] = events

  #   assert length(events) == 2
  #   assert h == "c2d06c4f-e1dc-4b2a-af61-ba15bc6d8610"
  #   assert t == "814695b6-f44e-491b-9921-af806f5bb25c"
  # end

  test "proposal_its_valid/1 shoud return false with an invalid param" do
    p1 = %{proposal_loan_value: 10000, proposal_number_of_monthly_installments: 8}
    p2 = %{proposal_loan_value: 10_000_000, proposal_number_of_monthly_installments: 360}
    p3 = %{proposal_loan_value: -10, proposal_number_of_monthly_installments: 0}
    p4 = %{proposal_loan_value: 0, proposal_number_of_monthly_installments: -99}

    assert LeadQualifier.proposal_its_valid?(p1) == false
    assert LeadQualifier.proposal_its_valid?(p2) == false
    assert LeadQualifier.proposal_its_valid?(p3) == false
    assert LeadQualifier.proposal_its_valid?(p4) == false
  end

  test "proposal_its_valid/1 shoud return true with a valid param" do
    p1 = %{proposal_loan_value: 30000, proposal_number_of_monthly_installments: 24}
    p2 = %{proposal_loan_value: 200_000, proposal_number_of_monthly_installments: 48}
    p3 = %{proposal_loan_value: 3_000_000, proposal_number_of_monthly_installments: 180}

    assert LeadQualifier.proposal_its_valid?(p1) == true
    assert LeadQualifier.proposal_its_valid?(p2) == true
    assert LeadQualifier.proposal_its_valid?(p3) == true
  end

  test "proponents_are_valid/2 should return true with a valid model " do
    %{events: events_one} = @input_one
    %{events: events_two} = @input_two

    assert true ==
             LeadQualifier.proponents_are_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert true ==
             LeadQualifier.proponents_are_valid?(events_two, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })
  end

  test "proponents_are_valid/2 should return false with an invalid model " do
    %{events: invalid_events} = EventProcessor.process(FileReader.read("invalid_proponent.txt"))

    assert false ==
             LeadQualifier.proponents_are_valid?(invalid_events, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })

    assert false ==
             LeadQualifier.proponents_are_valid?([], %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })

    assert false ==
             LeadQualifier.proponents_are_valid?(nil, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })
  end

  test "warranties_its_valid/2 should return true with a valid model " do
    %{events: events_one} = @input_one
    %{events: events_two} = @input_two

    assert true ==
             LeadQualifier.warranties_its_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert true ==
             LeadQualifier.warranties_its_valid?(events_two, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })
  end

  test "warranties_its_valid/2 should return true with an invalid model " do
    %{events: events_one} = EventProcessor.process(FileReader.read("invalid_warranty.txt"))

    assert false ==
             LeadQualifier.warranties_its_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4e"
             })

    assert false ==
             LeadQualifier.warranties_its_valid?(events_one, %{
               proposal_id: "af6e600b-2622-40d1-89ad-d3e5b6cc2fdf"
             })

    assert false ==
             LeadQualifier.warranties_its_valid?(events_one, %{
               proposal_id: "bd6abe95-7c44-41a4-92d0-edf4978c9f4i"
             })
  end
end
