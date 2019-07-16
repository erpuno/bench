defmodule BenchTest do
  use ExUnit.Case
  doctest Bench

  test "greets the world" do
    assert Bench.hello() == :world
  end
end
