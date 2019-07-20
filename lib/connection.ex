defmodule Connection do
  use N2O

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :tls})
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:ok, pi(p, state: {conn,ref})}
  end

  def proc({:gun_ws, pid, ref, msg}, p) do
    IO.inspect msg
    {:reply, [], p}
  end

  def proc({:send_msg, message}, pi(state: {conn,_}) = p) do
    :gun.ws_send(conn, {:text, message})
    {:reply, [], p}
  end

  def proc(m,p) do
    IO.inspect(m)
    {:reply, [], p}
  end

end
