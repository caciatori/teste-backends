defmodule BcrediApp.Warranty do
  alias BcrediApp.{EventEnumerable, Proposal}

  def warranties_its_valid?(events, %{:proposal_id => proposal_id}) do
    warranties = EventEnumerable.filter_by_schema_and_proposal_id(events, :warranty, proposal_id)

    warranties = remove_warranties_in_provinces_not_allowed(warranties)

    proposal = Proposal.find_proposal_by_id(events, proposal_id)

    length(warranties) > 0 && warranty_value_is_valid?(warranties, proposal)
  end

  def warranty_value_is_valid?(warranties, proposal) do
    %{proposal_loan_value: proposal_loan_value} = proposal

    warranties_value =
      warranties
      |> Enum.map(& &1.warranty_value)
      |> Enum.reduce(&(&1 + &2))

    warranties_value >= proposal_loan_value * 2
  end

  def remove_warranties_in_provinces_not_allowed(warranties) do
    Enum.filter(warranties, &(&1.warranty_province not in ["PR", "SC", "RS"]))
  end
end
