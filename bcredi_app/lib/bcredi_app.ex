defmodule BcrediApp do

  alias BcrediApp.{FileReader, Processor}
  def start do
    {:ok, pid} = Supervisor.start_child(BcrediApps.Supervisor, [])
    pid
  end

  def process_message(pid) do
    Processor.execute(FileReader.read_model_one())
    |> send_messages(pid)
  end

  def send_messages(message, pid) do
    %{events: events} = message

    import GenServer

    for event <- events do
      %{event_schema: event_schema, event_action: event_action} = event
      event_atom = :"#{event_action}_#{event_schema}"

      GenServer.call(pid, {event_atom, event})
    end
  end
end

