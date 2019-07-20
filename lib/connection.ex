defmodule Connection do

  def proc(:init, _pid) do
    :gun.open('localhost', 8042)
  end
end
