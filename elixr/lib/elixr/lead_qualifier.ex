defmodule Elixr.LeadQualifier do
  alias Elixr.{Proponent, Proposal}

  def qualify(input) do
    nil
  end

  defdelegate proposal_its_valid?(event), to: Proposal
  defdelegate proponents_are_valid?(events, event), to: Proponent
end
