defmodule Elixr.Warranty do
  alias Elixr.EventEnumerable

  def warranties_its_valid?(events, %{:proposal_id => proposal_id}) do
    warranties = EventEnumerable.find_by_schema_and_proposal_id(events, :warranty, proposal_id)

    length(warranties) > 0
  end

  def warranty_value_is_valid(warranties) do

  end
end
