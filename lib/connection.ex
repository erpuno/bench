defmodule Connection do
  use N2O

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042)
    {:ok, pi(p, state: conn)}
  end

  def proc(_,p), do: {:reply, [], p}
end
