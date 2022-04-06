defmodule ZiosPizza.Pizzas.Router do
  use Plug.Router
  use Plug.ErrorHandler

  #alias ZiosPizza.Pizzas.Repo
  alias ZiosPizza.Pizzas.Cache

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    pizzas = Enum.map(Cache.get_pizzas, &project/1)

    # ZiosPizza.Pizzas.Cache.load_pizzas()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(pizzas))
  end

  defp project(p) do
    %{id: p.id, name: p.name, price: p.price}
  end

  match(_, do: send_resp(conn, 404, "Not found"))
end
