defmodule EcommerceWeb.ProductLive.Index do
  use EcommerceWeb, :live_view
  alias Ecommerce.Products

  embed_templates "product_templates/*"


  @impl true
  def mount(_params, _session, socket) do
    products = Products.list_products()
    {:ok, assign(socket, products: products, cart: %{}, page_title: "Products")}
  end

  

end
