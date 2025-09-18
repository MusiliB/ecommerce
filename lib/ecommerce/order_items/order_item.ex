defmodule Ecommerce.Store.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :quantity, :integer
    field :price, :decimal
    belongs_to :order, Ecommerce.Store.Order
    belongs_to :product, Ecommerce.Store.Product

    timestamps()
  end

  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity, :price, :order_id, :product_id])
    |> validate_required([:quantity, :price, :order_id, :product_id])
    |> validate_number(:quantity, greater_than: 0)
    |> assoc_constraint(:order)
    |> assoc_constraint(:product)
  end
end
