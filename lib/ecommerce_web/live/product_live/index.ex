defmodule EcommerceWeb.ProductLive.Index do
  use EcommerceWeb, :live_view
  alias Ecommerce.Products

  on_mount {EcommerceWeb.UserAuth, :mount_current_scope}

  embed_templates "product_templates/*"

  @impl true
  def render(assigns) do
    index(assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    products = Products.list_products()
    {:ok, assign(socket, products: products, cart: %{}, page_title: "Products")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params), do: socket

  defp apply_action(socket, :admin_index, _params),
    do: assign(socket, page_title: "Admin - Products")

  defp apply_action(socket, :manager_index, _params),
    do: assign(socket, page_title: "Manager - Products")

  defp apply_action(socket, :new, _params) do
    product = %Products.Product{}

    assign(socket,
      page_title: "New Product",
      product: product,
      changeset: Products.Product.changeset(product, %{})
    )
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    product = Products.get_product!(id)

    assign(socket,
      page_title: "Edit Product",
      product: product,
      changeset: Products.Product.changeset(product, %{})
    )
  end

  @impl true
  def handle_event("add_to_cart", %{"product_id" => pid_str}, socket) do
    case Integer.parse(pid_str) do
      {pid, ""} ->
        case Products.get_product!(pid) do
          nil ->
            {:noreply, put_flash(socket, :error, "Product not found")}

          _product ->
            cart = Map.update(socket.assigns.cart, pid, 1, &(&1 + 1))
            {:noreply, assign(socket, cart: cart)}
        end

      :error ->
        {:noreply, put_flash(socket, :error, "Invalid product id")}
    end
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      %Products.Product{}
      |> Products.Product.changeset(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.live_action, product_params)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)
    {:noreply, assign(socket, products: Products.list_products())}
  end

  def handle_event("remove_from_cart", %{"product_id" => pid_str}, socket) do
    {pid, ""} = Integer.parse(pid_str)
    {:noreply, assign(socket, cart: Map.delete(socket.assigns.cart, pid))}
  end

  def handle_event("update_quantity", %{"product_id" => pid_str, "quantity" => qty_str}, socket) do
    {pid, ""} = Integer.parse(pid_str)
    {qty, ""} = Integer.parse(qty_str)

    cart =
      if qty <= 0,
        do: Map.delete(socket.assigns.cart, pid),
        else: Map.put(socket.assigns.cart, pid, qty)

    {:noreply, assign(socket, cart: cart)}
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully.")
         |> push_navigate(to: ~p"/admin/products")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_product(socket, :edit, product_params) do
    product = Products.get_product!(socket.assigns.product.id)

    case Products.update_product(product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully.")
         |> push_navigate(to: ~p"/admin/products")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
