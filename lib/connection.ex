defmodule Connection do
  use N2O

  def timer_restart(), do: :erlang.send_after(20000, self(), {:timer, :ping})

  def proc(:init, p) do
    {:ok, conn} = :gun.open('chat-1.n2o.dev', 8042, %{protocols: [:http], transport: :tls}) # 'chat-2.n2o.space' - server host
    :gun.ws_upgrade(conn, "/ws", [])
    {:ok, p}
  end

  def proc({:timer, :ping}, pi(state: {[], [], []}) = p) do
    {:reply, [], p}
  end

  def proc({:timer, :ping}, pi(state: {conn, ref, timer}) = p) do
    :erlang.cancel_timer(timer)
    :gun.ws_send(conn, {:text, "PING"})
    {:reply, [], pi(p, state: {conn, ref, timer_restart()})}
  end

  def proc({:gun_ws, _, _, {:text, "PONG"}}, p) do
    {:reply, [], p}
  end

  def proc({:gun_ws, _, _, msg}, p) do
    IO.inspect("Income #{inspect(msg)}")
    {:reply, [], p}
  end

  def proc({:gun_up, conn, :http}, pi(name: name) = p) do
    IO.inspect("Up #{name}")
    ref = :gun.ws_upgrade(conn, "/ws", [])
    {:ok, pi(p, state: {conn, ref, timer_restart()})}
  end

  def proc({:gun_upgrade, conn, ref, _ws, _headers}, pi(name: name, state: {_, _, timer}) = p) do
    :erlang.cancel_timer(timer)
    IO.inspect("Upgrade #{name}")
    send(:n2o_pi.pid(:caching, name), {:send_msg, "AUTH #{name}"}) # Auth as a bench client
    {:reply, [], pi(p, state: {conn, ref, timer_restart()})}
  end

  def proc({:gun_down, _, _proto, _reason, _, _}, pi(name: name) = p) do
    IO.inspect("Down #{name}")
    {:reply, [], pi(p, state: {[], [], []})}
  end

  def proc({:send_msg, message}, pi(name: name, state: {conn, _, _}) = p) do
    IO.inspect("Send #{name}")
    :gun.ws_send(conn, {:text, message})
    {:reply, [], p}
  end

  def proc(m, p) do
    IO.inspect("Unknown #{inspect(m)}")
    {:reply, [], p}
  end
end
