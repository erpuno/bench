defmodule Connection do
  use N2O

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :tls})
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:ok, pi(p, state: {conn,ref})}
  end

  def proc({:gun_ws, conn, ref, msg}, p) do
    IO.inspect "Income #{inspect(msg)}"
    {:reply, [], p}
  end

  def proc({:gun_up, conn, :http}, pi(name: name)=p) do
    IO.inspect "Up #{inspect(name)}"
    :gun.ws_upgrade(conn, "/ws", [])
    {:ok, p}
  end

  def proc({:gun_upgrade, conn, _ref, _ws, _headers}, p) do
    {:reply, [], p}
  end

  def proc({:gun_down, conn, _proto, _reason, _, _}, pi(name: name)=p) do
    IO.inspect "Down #{inspect(name)}"
    {:reply, [], p}
  end

  def proc({:send_msg, message}, pi(state: {conn,_}) = p) do
    IO.inspect "Send #{inspect(conn)}"
    :gun.ws_send(conn, {:text, message})
    {:reply, [], p}
  end

  def proc(m,p) do
    IO.inspect "Unknown #{inspect(m)}"
    {:reply, [], p}
  end

end
