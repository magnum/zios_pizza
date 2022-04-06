defmodule ZiosPizza.Cart.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  describe "Cart router" do
    test "POST /cart should create a new cart" do
      conn =
        conn(:post, "/cart", %{pizza_id: 2})
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer user1")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert conn.status == 201

      pizza = Enum.at(res["pizzas"], 0)
      assert pizza["id"] == 2
      assert res["total"] == 450
    end

    test "POST /cart should create a cart w/ multiple pizzas" do
      conn =
        conn(:post, "/cart", %{pizza_id: 2})
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer user2")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))
      conn =
        conn(:post, "/cart", %{pizza_id: 2})
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer user2")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert conn.status == 201

      pizza = Enum.at(res["pizzas"], 0)
      assert pizza["id"] == 2
      assert pizza["qty"] == 2
      assert res["total"] == 900
    end

  end
end
