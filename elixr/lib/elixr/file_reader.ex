defmodule Elixr.FileReader do
  @moduledoc """
  Module that reads input models in the assets folder
  """
  @assets_path "../../assets"

  def read_model_one() do
    "#{@assets_path}/model_one.txt"
    |> read_file()
  end

  def read_model_two() do
    "#{@assets_path}/model_two.txt"
    |> read_file()
  end

  defp read_file(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.read!()
  end
end
