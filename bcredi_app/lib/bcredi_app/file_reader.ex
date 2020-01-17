defmodule BcrediApp.FileReader do
  @moduledoc """
  Module that reads input models at assets folder
  """
  @assets_path "../../assets"

  def read_model_one do
    "#{@assets_path}/model_one.txt"
    |> read_file()
  end

  def read_model_two do
    "#{@assets_path}/model_two.txt"
    |> read_file()
  end

  def read(file_name) do
    "#{@assets_path}/#{file_name}"
    |> read_file()
  end

  defp read_file(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
  end
end
