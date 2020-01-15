defmodule Elixr.EventProcessor do
  alias Elixr.{Event, EventEnumerable}

  defstruct(
    events: [],
    total_of_events: 0
  )

  def process(""), do: nil
  def process(nil), do: nil

  def process(message) do
    message
    |> String.split("\n")
    |> transform()
  end

  defp transform(str_list) do
    %{
      events: parse_events(str_list),
      total_of_events: parse_total_of_events(str_list)
    }
  end

  defp parse_total_of_events([head | _tail]), do: String.to_integer(head)

  defp parse_events([_head | events]) do
    events
    |> Enum.map(fn event -> event |> String.split(",") end)
    |> Enum.map(&convert_list_to_struct/1)
    |> Enum.sort(&EventEnumerable.by_datetime_asc/2)
    |> Enum.uniq_by(&event_id/1)
  end

  defp event_id(event = %Event{}) do
    event.event_id
  end

  defp convert_list_to_struct(event) do
    {event_data, proposal_data} = Enum.split(event, 4)

    parse_event(event_data, proposal_data)
  end

  defp parse_event(event_data, proposal_data) when length(proposal_data) == 6 do
    [
      proposal_id,
      proponent_id,
      proponent_name,
      proponent_age,
      proponent_monthly_income,
      proponent_is_main
    ] = proposal_data

    %{
      build_event_struct(event_data)
      | proposal_id: proposal_id,
        proponent_id: proponent_id,
        proponent_name: proponent_name,
        proponent_age: String.to_integer(proponent_age),
        proponent_monthly_income: String.to_float(proponent_monthly_income),
        proponent_is_main: proponent_is_main
    }
  end

  defp parse_event(event_data, proposal_data) when length(proposal_data) == 4 do
    [
      proposal_id,
      warranty_id,
      warranty_value,
      warranty_province
    ] = proposal_data

    %{
      build_event_struct(event_data)
      | proposal_id: proposal_id,
        warranty_id: warranty_id,
        warranty_value: String.to_float(warranty_value),
        warranty_province: warranty_province
    }
  end

  defp parse_event(event_data, proposal_data) when length(proposal_data) == 3 do
    [
      proposal_id,
      proposal_loan_value,
      proposal_number_of_monthly_installments
    ] = proposal_data

    %{
      build_event_struct(event_data)
      | proposal_id: proposal_id,
        proposal_loan_value: String.to_float(proposal_loan_value),
        proposal_number_of_monthly_installments:
          String.to_integer(proposal_number_of_monthly_installments)
    }
  end

  defp parse_event(event_data, _) do
    build_event_struct(event_data)
  end

  defp build_event_struct(event_data) do
    [event_id, event_schema, event_action, event_timestamp] = event_data

    %Event{
      event_id: event_id,
      event_schema: String.to_atom(event_schema),
      event_action: String.to_atom(event_action),
      event_timestamp: string_to_datetime(event_timestamp)
    }
  end

  defp string_to_datetime(event_timestamp) do
    {:ok, date, _utc} = DateTime.from_iso8601(event_timestamp)
    date
  end
end
