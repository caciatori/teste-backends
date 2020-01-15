defmodule Elixr.EventEnumerable do
  def find_by_schema(nil, _), do: []
  def find_by_schema([], _), do: []

  def find_by_schema(list, schema) do
    Enum.filter(list, &(&1.event_schema == schema))
    |> Enum.sort(&by_datetime_desc/2)
  end

  def by_datetime_asc(e1 = %{}, e2 = %{}) do
    e1.event_timestamp <= e2.event_timestamp
  end

  def by_datetime_desc(e1 = %{}, e2 = %{}) do
    e1.event_timestamp >= e2.event_timestamp
  end
end
