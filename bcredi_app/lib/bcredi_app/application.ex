defmodule BcrediApp.Application do
  @moduledoc """
  Application module
  """
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(BcrediApp.Server, [])
    ]

    options = [
      name: BcrediApps.Supervisor,
      strategy: :simple_one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
