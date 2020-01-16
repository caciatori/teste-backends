defmodule BcrediApp.Proponent do
  alias BcrediApp.{EventEnumerable, Proposal}

  def valid_proponents(%{:proposal_id => proposal_id}) do
    proponents = EventEnumerable.filter_by_schema_and_proposal_id(:proponent, proposal_id)

    if proponents_are_valid?(proponents, proposal_id) do
      proponents
    end

    []
  end

  defp proponents_are_valid?(proponents, proposal_id) do
    main_proponent = Enum.find(proponents, &(&1.proponent_is_main == true))
    loan_monthly_value = Proposal.monthly_loan_value(proposal_id)

    length(proponents) >= 2 &&
      Enum.all?(proponents, &they_are_adults?/1) &&
      Enum.any?(proponents, &someone_is_main?/1) &&
      income_is_enough?(loan_monthly_value, main_proponent)
  end

  defp income_is_enough?(loan_monthly_value, %{
         proponent_age: proponent_age,
         proponent_monthly_income: proponent_monthly_income
       }) do
    cond do
      proponent_age >= 18 && proponent_age <= 24 ->
        proponent_monthly_income >= loan_monthly_value * 4

      proponent_age >= 25 and proponent_age <= 50 ->
        proponent_monthly_income >= loan_monthly_value * 3

      proponent_age > 50 ->
        proponent_monthly_income >= loan_monthly_value * 2

      true ->
        false
    end
  end

  defp someone_is_main?(nil), do: false
  defp someone_is_main?([]), do: false

  defp someone_is_main?(%{proponent_is_main: proponent_is_main}) do
    proponent_is_main
  end

  defp they_are_adults?(nil), do: false
  defp they_are_adults?([]), do: false

  defp they_are_adults?(%{proponent_age: proponent_age}) do
    proponent_age >= 18
  end
end
