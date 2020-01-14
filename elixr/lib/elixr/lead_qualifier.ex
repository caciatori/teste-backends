defmodule Elixr.LeadQualifier do
  alias Elixr.{Event, EventProcessor, Proponent, Proposal, Warranty}

  def qualify(input) do
    %{events: events} = EventProcessor.process(input)
    events
  end

  def proposal_loan_value_valid?(%{proposal_loan_value: proposal_loan_value}) do
    proposal_loan_value >= 30_000 && proposal_loan_value <= 3_000_000
  end

  def proposal_number_of_monthly_installments_valid?(%{
        proposal_number_of_monthly_installments: proposal_number_of_monthly_installments
      }) do
    proposal_number_of_monthly_installments >= 24 &&
      proposal_number_of_monthly_installments <= 180
  end

  def proposal_has_more_than_one_proponent?(events, %{proposal_id: proposal_id}) do
    proponents = find_by_schema(events, :proponent)


    nil
  end

  defp find_by_schema(list, schema) do
    Enum.find(list, &(&1.event_schema == schema))
    |> Enum.sort(&by_datetime_desc/2)
  end

  defp by_datetime_desc(e1 = %Event{}, e2 = %Event{}) do
    e1.event_timestamp >= e2.event_timestamp
  end
end
