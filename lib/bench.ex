defmodule Bench do
  @moduledoc """
  Documentation for Bench.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Bench.hello()
      :world

  """
  def hello do
    for num <- 1..500 do
      x = Bench.Application.initialize("Bench #{num}")
      IO.inspect("User: #{num} pid: #{inspect(x)}")
    end
  end
end
