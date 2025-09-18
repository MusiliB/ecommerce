defmodule Ecommerce.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :price, :decimal, null: false
      add :description, :text
      add :stock, :integer, null: false
      add :image, :string

      timestamps()
    end
  end
end
