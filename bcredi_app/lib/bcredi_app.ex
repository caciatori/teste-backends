defmodule BcrediApp do
  @moduledoc """
  App model
  """
  alias BcrediApp.{Client, FileReader, Processor, Proponent, Proposal, Warranty}

  def start do
    {:ok, pid} = Supervisor.start_child(BcrediApps.Supervisor, [])
    pid
  end

  def process_local_message do
    FileReader.read_model_one() |> process_message()
  end

  def process_message(message) do
    Processor.execute(message) |> Client.send_messages()

    %{proposals: proposals} = Client.read_messages()

    proposals
    |> Enum.filter(&Proposal.proposal_its_valid?/1)
    |> Enum.filter(&Proponent.valid_proponents?/1)
    |> Enum.filter(&Warranty.warranties_its_valid?/1)
    |> Enum.map(& &1.proposal_id)
    |> Enum.join(",")
  end
end
