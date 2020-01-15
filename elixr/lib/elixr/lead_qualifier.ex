defmodule Elixr.LeadQualifier do
  alias Elixr.{Proponent, Proposal, Warranty}

  def qualify(input) do
    nil
  end

  defdelegate proponents_are_valid?(events, event), to: Proponent
  defdelegate proposal_its_valid?(event), to: Proposal
  defdelegate warranties_its_valid?(events, event), to: Warranty
end
