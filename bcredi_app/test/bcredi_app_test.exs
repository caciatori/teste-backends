defmodule BcrediAppTest do
  use ExUnit.Case
  doctest BcrediApp

  test "greets the world" do
    assert BcrediApp.hello() == :world
  end
end
