defmodule Elixr do
  alias Elixr.{EventProcessor, FileReader}

  def process_message() do
    EventProcessor.process(FileReader.read_model_one())
  end
end
