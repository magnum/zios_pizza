defmodule ZiosPizza.Cart.Server do
  use GenServer

  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: via_tuple(user_id))
  end

  def init(user_id) do
    state = %{total: 0, pizzas: [], user_id: user_id }
    {:ok, state}
  end

  def execute(id, cmd) do
    GenServer.call(via_tuple(id), cmd)
  end

  defp via_tuple(user_id) do
    {:via, Registry, {ZiosPizza.Cart.Registry, user_id}}
  end

  def handle_call({:add_pizza, pizza}, _from, state) do
    pizzas = state[:pizzas] ++ [pizza]
    state = %{
      pizzas: parse_pizzas(pizzas),
      total: calculate_total(pizzas)
    }
    {:reply, {:ok, state}, state}
  end


  def parse_pizzas(pizzas) do
    Enum.group_by(pizzas, &elem(&1, 0), &elem(&1, 1))
  end

  defp calculate_total(pizzas) do
    Enum.reduce(pizzas, 0, fn p, acc -> acc + p.price end)
  end

end
