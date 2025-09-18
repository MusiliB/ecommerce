defmodule Ecommerce.Orders do
  import Ecto.Query
  alias Ecommerce.Repo
  alias Ecommerce.Orders.Order

  def list_orders(user) do
    Repo.all(from o in Order, where: o.user_id == ^user.id, preload: [:order_items, :user])
  end

  def list_all_orders do
    Repo.all(from o in Order, preload: [:order_items, :user])
  end

  def get_order!(id), do: Repo.get!(Order, id) |> Repo.preload([:order_items, :user])
end
