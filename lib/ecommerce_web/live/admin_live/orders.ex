defmodule EcommerceWeb.AdminLive.Orders do
  use EcommerceWeb, :live_view

  embed_templates "admin_templates/*"

  @impl true
  def render(assigns), do: orders(assigns)
end
