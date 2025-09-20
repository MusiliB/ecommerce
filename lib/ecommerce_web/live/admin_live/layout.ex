defmodule EcommerceWeb.AdminLive.Layout do
  use EcommerceWeb, :live_view

  on_mount {EcommerceWeb.UserAuth, :mount_current_scope}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-screen bg-gray-100">
      <!-- Sidebar -->
      <aside class="w-64 bg-gray-900 text-gray-100 flex flex-col">
        <div class="px-6 py-4 text-xl font-bold border-b border-gray-700">
          Admin Dashboard
        </div>
        <nav class="flex-1 px-4 py-6 space-y-2">
          <.link navigate={~p"/dashboard"} class="block px-3 py-2 rounded hover:bg-gray-700">
            📊 Dashboard
          </.link>
          <.link navigate={~p"/dashboard/products"} class="block px-3 py-2 rounded hover:bg-gray-700">
            📦 Products
          </.link>
          <.link navigate={~p"/dashboard/orders"} class="block px-3 py-2 rounded hover:bg-gray-700">
            🛒 Orders
          </.link>
          <.link navigate={~p"/dashboard/users"} class="block px-3 py-2 rounded hover:bg-gray-700">
            👥 Users
          </.link>
        </nav>
        <div class="px-6 py-4 border-t border-gray-700">
          <form method="post" action={~p"/users/log-out"}>
            <button
              type="submit"
              class="w-full text-left px-3 py-2 rounded bg-red-600 hover:bg-red-700"
            >
              🚪 Logout
            </button>
          </form>
        </div>
      </aside>

    <!-- Main Content -->
      <main class="flex-1 p-8 overflow-y-auto">
        {@inner_content}
      </main>
    </div>
    """
  end
end
