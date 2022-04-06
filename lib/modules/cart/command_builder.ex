defmodule ZiosPizza.Cart.CommandBuilder do
  alias ExJsonSchema.Validator

  def build_add_pizza_cmd(payload) do
    payload_schema = %{
      "type" => "object",
      "properties" => %{
        "pizza_id" => %{"type" => "integer"}
      }
    }


    # case Validator.validate(payload_schema, payload) do
    #   :ok ->
    #     # verificare che pizza_id esista
    #     case ZiosPizza.Pizzas.Cache.get(payload["pizza_id"]) do
    #       :not_found -> {:error, :not_found}
    #       {:ok, pizza} -> {:ok, {:add_pizza, pizza}}
    #     end
    #   {:error, errors} ->
    #     {:error, errors}
    # end


    with :ok <- Validator.validate(payload_schema, payload),
      {:ok, pizza} <- ZiosPizza.Pizzas.Cache.get(payload["pizza_id"]) do
        {:ok, {:add_pizza, pizza}}
      else
        :not_found -> {:error, :not_found}
        {:error, errors} -> {:error, errors}
    end

  end
end
