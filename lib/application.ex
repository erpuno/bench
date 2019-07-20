defmodule Bench.Application do
  use Application
  use N2O

  def start(_, _) do
    x = Supervisor.start_link([], strategy: :one_for_one, name: :bench)
    initialize()
    x
  end

  def initialize() do
    IO.inspect :n2o_pi.start(pi(module: Connection,
                     table: :caching,
                     sup: :bench,
                     state: [],
                     name: "Bench"))
  end
end
