defmodule EcommerceWeb.AdminLive.Products do
  use EcommerceWeb, :live_view

  embed_templates "admin_templates/*"

  @impl true
  def render(assigns), do: products(assigns)
end
