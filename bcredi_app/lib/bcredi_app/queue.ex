defmodule BcrediApp.Queue do
  alias BcrediApp.Event

  defstruct(
    events: [],
    proponents: [],
    proposals: [],
    warranties: []
  )

  def initialize() do
    %{}
  end

  def action(:add_proponent, proponent, state) do
    current_state = Map.get(state, :proponents, [])

    Map.put(state, :proponents, [ current_state, proponent])
  end
end
