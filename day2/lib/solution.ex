defmodule Solution do
  use Agent

  def start_link(init) do
    Agent.start_link(fn -> init end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def update(new_value) when is_integer(new_value) do
    Agent.update(__MODULE__, fn _old_value -> new_value end)
  end
  def update(_) do
    Agent.update(__MODULE__, & &1)
  end
end
