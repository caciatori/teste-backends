defmodule BcrediApp.Client do
  @server_name :bapp

  @callback send_messages(list()) :: map()
  def send_messages(message) do
    %{events: events} = message

    for event <- events do
      %{event_schema: event_schema, event_action: event_action} = event
      event_atom = :"#{event_action}_#{event_schema}"

      GenServer.call(@server_name, {event_atom, event})
    end
  end

  @callback read_messages() :: list()
  def read_messages() do
    GenServer.call(@server_name, {:events})
  end
end
