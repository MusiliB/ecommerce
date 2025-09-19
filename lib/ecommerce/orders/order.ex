defmodule Ecommerce.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :date, :utc_datetime
    field :status, :string, default: "pending"
    belongs_to :user, Ecommerce.Accounts.User
    has_many :order_items, Ecommerce.OrderItems.OrderItem

    timestamps()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :date, :status])
    |> validate_required([:user_id, :date])
    |> assoc_constraint(:user)
  end
end
