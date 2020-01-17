defmodule BcrediApp.Proposal do
  @moduledoc """
  Module that validate Proposal
  """
  alias BcrediApp.EventEnumerable

  def proposal_its_valid?(proposal = %{}) do
    proposal_loan_value_valid?(proposal) &&
      proposal_number_of_monthly_installments_valid?(proposal)
  end

  def find_proposal_by_id(proposal_id) do
    EventEnumerable.filter_by_schema(:proposal)
    |> Enum.find(nil, &(&1.proposal_id == proposal_id))
  end

  def monthly_loan_value(proposal_id) do
    %{
      proposal_number_of_monthly_installments: proposal_number_of_monthly_installments,
      proposal_loan_value: proposal_loan_value
    } = find_proposal_by_id(proposal_id)

    Float.round(proposal_loan_value / proposal_number_of_monthly_installments, 2)
  end

  defp proposal_loan_value_valid?(%{proposal_loan_value: proposal_loan_value}) do
    proposal_loan_value >= 30_000 && proposal_loan_value <= 3_000_000
  end

  defp proposal_number_of_monthly_installments_valid?(%{
         proposal_number_of_monthly_installments: proposal_number_of_monthly_installments
       }) do
    proposal_number_of_monthly_installments >= 24 &&
      proposal_number_of_monthly_installments <= 180
  end
end
