defmodule Connection do
  use N2O

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :tls})
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:ok, pi(p, state: {conn,ref})}
  end

  def proc({:gun_up, conn, :http}, p) do
    IO.inspect "GUN UP"
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:reply, [], pi(p, state: {conn,ref})}
  end

  def proc({:gun_upgrade, conn, ref, proto, headers}, pi(state: {conn,ref}) = p) do
    IO.inspect "GUN UPGRADE"
    case :gun.await(conn,ref) do
    {:upgrade, _, _} -> IO.inspect("Successful WebSocket Upgrade")
                        {:reply, [], p}
                   x -> IO.inspect("Upgrade Error: #{inspect(x)}")
                        {:reply, [], p}
    end
  end

  def proc({:gun_down, _conn, _proto, _status, _, _}, p) do
    IO.inspect("GUN DOWN")
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :tls})
    {:reply, [], pi(p, state: {conn,[]})}
  end

  def proc({:gun_ws, pid, ref, msg}, p) do
    IO.inspect "GUN INCOME"
    IO.inspect msg
    {:reply, [], p}
  end

  def proc({:send_msg, message}, pi(state: {conn,_}) = p) do
    IO.inspect :gun.ws_send(conn, {:text, message})
    {:reply, [], p}
  end

  def proc(m,p) do
    IO.inspect(m)
    {:reply, [], p}
  end

end
