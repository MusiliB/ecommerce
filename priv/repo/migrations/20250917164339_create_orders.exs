defmodule Ecommerce.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, references(:users, on_delete: :restrict), null: false
      add :date, :utc_datetime, null: false
      add :status, :string, default: "pending"

      timestamps()
    end
  end
end
