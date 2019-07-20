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
    for num <- 1..10000 do
      Bench.Application.initialize("Bench #{num}")
      :timer.sleep 1
    end
  end
end
