defmodule Elixr.LeadQualifierTest do
  use ExUnit.Case
  alias Elixr.{FileReader, LeadQualifier}

  @input_one FileReader.read_model_one()

  # test "Should return two valid proposals" do
  #   %{events: events, total_of_events: total_of_events} = LeadQualifier.qualify(@input_one)
  #   [h | t] = events

  #   assert length(events) == 2
  #   assert h == "c2d06c4f-e1dc-4b2a-af61-ba15bc6d8610"
  #   assert t == "814695b6-f44e-491b-9921-af806f5bb25c"
  # end

  test "proposal_loan_value is invalid" do
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: 10000}) == false
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: 10_000_000}) == false
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: -10}) == false
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: 0}) == false
  end

  test "proposal_loan_value is valid" do
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: 30000}) == true
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: 200_000}) == true
    assert LeadQualifier.proposal_loan_value_valid?(%{proposal_loan_value: 3_000_000}) == true
  end

  test "proposal_number_of_monthly_installments_valid is invalid" do
    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: 8
           }) == false

    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: 360
           }) == false

    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: 0
           }) == false

    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: -99
           }) == false
  end

  test "proposal_number_of_monthly_installments_valid is valid" do
    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: 24
           }) == true

    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: 48
           }) == true

    assert LeadQualifier.proposal_number_of_monthly_installments_valid?(%{
             proposal_number_of_monthly_installments: 180
           }) == true
  end
end
