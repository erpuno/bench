defmodule Bench do
  @moduledoc """
  Documentation for Bench.
  """

  @clients 1000

  @doc """
  Runs N number of Clients
  Setup the number of clients in the static variable in Bench module

  ## Examples

      iex> Bench.run()
      :ok

  """
  def run do
    for client <- 1..@clients do # C50K is doable on MacBook Air
      Bench.Application.initialize("Bench_#{client}")
      :timer.sleep 1
    end
  end

  @doc """
  Send N number of Messages to from/to random running Bench clients

  ## Examples

      iex> Bench.send_msgs(10)
      [
        send_msg: "SEND Bench_764 Message_1",
        send_msg: "SEND Bench_589 Message_2",
        send_msg: "SEND Bench_974 Message_3",
        send_msg: "SEND Bench_891 Message_4",
        send_msg: "SEND Bench_577 Message_5",
        send_msg: "SEND Bench_388 Message_6",
        send_msg: "SEND Bench_159 Message_7",
        send_msg: "SEND Bench_393 Message_8",
        send_msg: "SEND Bench_181 Message_9",
        send_msg: "SEND Bench_464 Message_10"
      ]

  """
  def send_msgs(count) do
    for num <- 1..count do
      sender = "Bench_#{:rand.uniform(@clients)}"
      receiver = "Bench_#{:rand.uniform(@clients)}"
      send(:n2o_pi.pid(:caching, sender), {:send_msg, "SEND #{receiver} Message_#{num}"})
    end
  end

end
