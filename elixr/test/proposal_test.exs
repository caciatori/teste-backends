defmodule Elixr.ProposalTest do
  use ExUnit.Case
  alias Elixr.Proposal

  test "proposal_its_valid/1 shoud return false with an invalid param" do
    p1 = %{proposal_loan_value: 10000, proposal_number_of_monthly_installments: 8}
    p2 = %{proposal_loan_value: 10_000_000, proposal_number_of_monthly_installments: 360}
    p3 = %{proposal_loan_value: -10, proposal_number_of_monthly_installments: 0}
    p4 = %{proposal_loan_value: 0, proposal_number_of_monthly_installments: -99}

    assert Proposal.proposal_its_valid?(p1) == false
    assert Proposal.proposal_its_valid?(p2) == false
    assert Proposal.proposal_its_valid?(p3) == false
    assert Proposal.proposal_its_valid?(p4) == false
  end

  test "proposal_its_valid/1 shoud return true with a valid param" do
    p1 = %{proposal_loan_value: 30000, proposal_number_of_monthly_installments: 24}
    p2 = %{proposal_loan_value: 200_000, proposal_number_of_monthly_installments: 48}
    p3 = %{proposal_loan_value: 3_000_000, proposal_number_of_monthly_installments: 180}

    assert Proposal.proposal_its_valid?(p1) == true
    assert Proposal.proposal_its_valid?(p2) == true
    assert Proposal.proposal_its_valid?(p3) == true
  end
end
