defmodule Elixr.Proponent do
  alias Elixr.EventEnumerable

  def proponents_are_valid?(events, %{:proposal_id => proposal_id}) do
    proponents =
      EventEnumerable.find_by_schema(events, :proponent)
      |> Enum.filter(&(&1.proposal_id == proposal_id))

    length(proponents) == 2 &&
      Enum.all?(proponents, &they_are_adults?/1) &&
      Enum.any?(proponents, &someone_is_main?/1)
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
