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
      Bench.Application.initialize("Bench #{num}")
    end
  end
end
