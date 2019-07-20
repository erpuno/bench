
defmodule Connection do
  use N2O

  def timer_restart(), do: :erlang.send_after(30000,self(),{:timer,:ping})

  def proc(:init, p) do
    {:ok, conn} = :gun.open('localhost', 8042, %{protocols: [:http], transport: :tls})
    ref = :gun.ws_upgrade(conn, "/ws", [])
    timer = timer_restart()
    {:ok, pi(p, state: {conn,ref,timer})}
  end

  def proc({:timer, :ping}, pi(state: {[],[],[]})=p) do
    {:reply, [], p}
  end

  def proc({:timer, :ping}, pi(state: {conn,ref,timer})=p) do
    :erlang.cancel_timer(timer)
    :gun.ws_send(conn, {:text, "PING"})
    {:reply, [], pi(p, state: {conn,ref,timer_restart()})}
  end

  def proc({:gun_ws, _, _, {:text, "PONG"}}, p), do: {:reply, [], p}

  def proc({:gun_ws, _, _, msg}, p) do
    IO.inspect "Income #{inspect(msg)}"
    {:reply, [], p}
  end

  def proc({:gun_up, conn, :http}, pi(name: name)=p) do
    IO.inspect "Up #{inspect(name)}"
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:ok, pi(p, state: {conn,ref,timer_restart()})}
  end

  def proc({:gun_upgrade, _, _ref, _ws, _headers}, p) do
    {:reply, [], p}
  end

  def proc({:gun_down, _, _proto, _reason, _, _}, pi(name: name)=p) do
    IO.inspect "Down #{inspect(name)}"
    {:reply, [], pi(p,state: {[],[],[]})}
  end

  def proc({:send_msg, message}, pi(name: name, state: {conn,_,_}) = p) do
    IO.inspect "Send #{inspect(name)}"
    :gun.ws_send(conn, {:text, message})
    {:reply, [], p}
  end

  def proc(m,p) do
    IO.inspect "Unknown #{inspect(m)}"
    {:reply, [], p}
  end

end
