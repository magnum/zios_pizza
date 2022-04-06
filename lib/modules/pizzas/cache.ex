defmodule ZiosPizza.Pizzas.Cache do
  use GenServer
  alias ZiosPizza.Pizzas.Repo

  # TODO
  # - all'avvio caricare elenco pizze
  # - funzione per recupero pizze da parte del client
  # - meccanismo di refresh della cache


  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  defp schedule_refresh do
    Process.send_after(__MODULE__, :refresh, 60*1000)
  end

  @spec init(any) :: {:ok, [], {:continue, :load_pizzas}}
  def init(_args) do
    schedule_refresh()
    {:ok, [], {:continue, :load_pizzas}}
  end

  def handle_continue(:load_pizzas, _state) do
    ## caricamento pizze
    {:noreply, Repo.get_all()}
  end

  def get_pizzas do
    GenServer.call(__MODULE__, :get_pizzas)
  end


  def handle_call(:get_pizzas, _from, pizzas) do
    {:reply, pizzas, pizzas}
  end


  def handle_info(:refresh, _state) do
    schedule_refresh()
    {:noreply, Repo.get_all()}
  end



end
