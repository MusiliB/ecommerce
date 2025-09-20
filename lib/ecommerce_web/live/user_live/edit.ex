defmodule EcommerceWeb.UserLive.Edit do
  use EcommerceWeb, :live_view
  alias Ecommerce.Accounts

  on_mount {EcommerceWeb.UserAuth, :mount_current_scope}
  embed_templates "user_templates/*"

  @impl true
  def render(assigns), do: edit(assigns)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     assign(socket,
       page_title: "Edit User",
       user: user,
       changeset: Accounts.change_user(user)
     )}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully.")
         |> push_navigate(to: ~p"/dashboard/users")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
