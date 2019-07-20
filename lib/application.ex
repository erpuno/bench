defmodule Bench.Application do
  use Application
  use N2O

  def start(_, _) do
    initialize()
    Supervisor.start_link([], strategy: :one_for_one, name: Bench.Supervisor)
  end

  def initialize() do
    :n2o_pi.start(pi(module: Connection,
                     table: :caching,
                     sup: Bench.Supervisor,
                     state: [],
                     name: "Bench"))
  end
end
