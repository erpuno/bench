defmodule Connection do
  use N2O

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :ssl})
    {:ok, _} = :gun.await_up(conn)
    {:ok, pi(p, state: conn)}
  end

  def proc({:send_msg, message}, pi(state: conn)) do
    :gun.ws_send(conn, message)
  end

  def proc({:gun_up, conn, :http}, _p) do
    IO.inspect("GUN IS UP!")
    :gun.ws_upgrade(conn, "/ws", [])
  end

  def proc({:gun_upgrade, conn, ref}, _p) do
    IO.inspect("GUN UPGRADE TO WS!")
    {:upgrade, _} = :gun.await(conn, ref)
  end

  def proc({:gun_down, _conn, :http, :closed, _, _}, _p) do
    IO.inspect("GUN IS DOWN!")
  end

  def proc(m,p) do
    IO.inspect(m)
    {:reply, [], p}
  end

end
