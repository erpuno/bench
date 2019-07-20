defmodule Connection do
  use N2O

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :ssl})
    {:ok, pi(p, state: {conn,[]})}
  end

  def proc({:gun_up, conn, :http}, p) do
    IO.inspect "GUN UP"
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:reply, [], pi(p, state: {conn,ref})}
  end

  def proc({:gun_upgrade, conn, ref, _, headers}, pi(state: {conn,ref}) = p) do
    IO.inspect "GUN UPGRADE"
    case :gun.await(conn, ref) do
    {:upgrade, _, _} -> IO.inspect("Successful WebSocket Upgrade")
                     {:reply, [], p}
               p -> IO.inspect("Upgrade Error: #{inspect(p)}")
                     {:ok, p}   
    end
  end

  def proc({:gun_down, _conn, :http, :closed, _, _}, p) do
    IO.inspect("GUN DOWN")
    {:reply, [], p}
  end

  def proc({:send_msg, message}, pi(state: conn) = p) do
    IO.inspect :gun.ws_send(conn, message)
    {:reply, [], p}
  end

  def proc(m,p) do
    IO.inspect(m)
    {:reply, [], p}
  end

end
