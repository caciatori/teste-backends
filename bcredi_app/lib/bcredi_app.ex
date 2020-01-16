defmodule BcrediApp do
  import GenServer
  alias BcrediApp.{FileReader, Processor, Event, Proposal, Proponent, Warranty}

  def start do
    {:ok, pid} = Supervisor.start_child(BcrediApps.Supervisor, [])
    pid
  end

  def process_local_message() do
    FileReader.read_model_one() |> process_message()
  end

  def process_message(message) do
    Processor.execute(message)
    |> send_messages(:bapp)

    %{proposals: proposals} = Event.read_messages()

    proposals
    |> Enum.filter(&Proposal.proposal_its_valid?/1)
    |> Enum.filter(&Proponent.valid_proponents/1)
    |> Enum.filter(&Warranty.warranties_its_valid?/1)
    |> Enum.map(& &1.proposal_id)
    |> Enum.join(",")
  end

  defp send_messages(message, pid) do
    %{events: events} = message

    for event <- events do
      %{event_schema: event_schema, event_action: event_action} = event
      event_atom = :"#{event_action}_#{event_schema}"

      GenServer.call(pid, {event_atom, event})
    end
  end
end
