defmodule Ecommerce.Products.Product do

  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :decimal
    field :description, :string
    field :stock, :integer
    field :image, :string

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :description, :stock, :image])
    |> validate_required([:name, :price, :stock])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_number(:stock, greater_than_or_equal_to: 0)
  end
end
