defmodule EcommerceWeb.AdminLive.Products do
  use EcommerceWeb, :live_view
  alias Ecommerce.Products

  embed_templates "admin_templates/*"

@impl true
def render(assigns) do
  case assigns.live_action do
    :index -> products_index(assigns)
    :new   -> products_form(assigns)
    :edit  -> products_form(assigns)
  end
end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, products: Products.list_products(), changeset: nil, product: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # 🟢 Handle index (list products)
  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Products")
    |> assign(:product, nil)
    |> assign(:changeset, nil)
  end

  # 🟢 Handle new product form
  defp apply_action(socket, :new, _params) do
    product = %Products.Product{}
    changeset = Products.Product.changeset(product, %{})

    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, product)
    |> assign(:changeset, changeset)
  end

  # 🟢 Handle edit product form
  defp apply_action(socket, :edit, %{"id" => id}) do
    product = Products.get_product!(id)
    changeset = Products.Product.changeset(product, %{})

    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, product)
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      %Products.Product{}
      |> Products.Product.changeset(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.live_action, product_params)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, assign(socket, products: Products.list_products())}
  end

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully.")
         |> push_navigate(to: ~p"/dashboard/products")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully.")
         |> push_navigate(to: ~p"/dashboard/products")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
