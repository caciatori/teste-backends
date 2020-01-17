defmodule BcrediApp.EventEnumerable do
  alias BcrediApp.Client

  @client Application.get_env(:bcredi_app, :client, Client)

  def filter_by_schema_and_proposal_id(schema, proposal_id) do
    filter_by_schema(schema)
    |> Enum.filter(&(&1.proposal_id == proposal_id))
  end

  def filter_by_schema(schema) do
    result = @client.read_messages()

    cond do
      :proposal == schema ->
        %{proposals: proposals} = result
        proposals

      :proponent == schema ->
        %{proponents: proponents} = result
        proponents

      :warranty == schema ->
        %{warranties: warranties} = result
        warranties
    end
  end

  def by_datetime_asc(e1 = %{}, e2 = %{}) do
    e1.event_timestamp <= e2.event_timestamp
  end

  def by_datetime_desc(e1 = %{}, e2 = %{}) do
    e1.event_timestamp >= e2.event_timestamp
  end
end
