defmodule BcrediApp.Event do
  defstruct(
    event_id: nil,
    event_schema: nil,
    event_action: nil,
    event_timestamp: nil,
    proposal_id: nil,
    proposal_loan_value: nil,
    proposal_number_of_monthly_installments: nil,
    warranty_id: nil,
    warranty_value: nil,
    warranty_province: nil,
    proponent_id: nil,
    proponent_name: nil,
    proponent_age: nil,
    proponent_monthly_income: nil,
    proponent_is_main: nil
  )

  def read_messages() do
    import GenServer
    GenServer.call(:bapp, {:events})
  end
end
