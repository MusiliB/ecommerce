defmodule EcommerceWeb.UserLive.Index do
  use EcommerceWeb, :live_view
  alias Ecommerce.Accounts

  on_mount {EcommerceWeb.UserAuth, :mount_current_scope}

  embed_templates "user_templates/*"

  @impl true
  def render(assigns) do
    index(assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    # you must define this in Accounts
    users = Accounts.list_users()
    {:ok, assign(socket, users: users, page_title: "Users")}
  end
end
