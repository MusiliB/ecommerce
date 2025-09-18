defmodule Ecommerce.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :product_id, references(:products, on_delete: :restrict), null: false
      add :quantity, :integer, null: false
      add :price, :decimal, null: false

      timestamps()
    end
  end
end
