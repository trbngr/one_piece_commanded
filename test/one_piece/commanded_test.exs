defmodule OnePiece.CommandedTest do
  use ExUnit.Case
  doctest OnePiece.Commanded

  test "greets the world" do
    assert OnePiece.Commanded.hello() == :world
  end
end
