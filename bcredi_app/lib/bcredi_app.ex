defmodule BcrediApp do
  def start do
    {:ok, pid} = Supervisor.start_child(BcrediApps.Supervisor, [])
    pid
  end

  def process_message(message) do
    message
  end
end
