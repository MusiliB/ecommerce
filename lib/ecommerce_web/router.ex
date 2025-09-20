defmodule EcommerceWeb.Router do
  use EcommerceWeb, :router

  import EcommerceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EcommerceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_auth do
    plug :require_authenticated_user
  end

  pipeline :require_admin do
    plug :require_authenticated_user
    plug :require_role, [:admin]
  end

  pipeline :require_manager do
    plug :require_authenticated_user
    plug :require_role, [:manager]
  end

  ## Public routes
  scope "/", EcommerceWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  ## Normal authenticated user routes
  scope "/", EcommerceWeb do
    pipe_through [:browser, :require_auth]

    # ✅ normal user
    live "/products", ProductLive.Index, :index
    live "/cart", CartLive.Index, :index
    live "/cart/checkout", CartLive.Checkout, :checkout
    live "/orders", OrderLive.Index, :index

    live_session :require_authenticated_user,
      on_mount: [{EcommerceWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  ## Admin/manager  routes
  scope "/dashboard", EcommerceWeb do
    pipe_through [:browser, :require_admin]

    live_session :admin,
      on_mount: [{EcommerceWeb.UserAuth, :mount_current_scope}],
      layout: {EcommerceWeb.AdminLive.Layout, :render} do
      live "/", AdminLive.Dashboard, :index
      live "/products", AdminLive.Products, :products
      live "/orders", AdminLive.Orders, :orders
      live "/users", UserLive.Index, :index
    end

    live "/users/:id/edit", UserLive.Edit, :edit

    # Shared product management routes
    scope "/products" do
      live "/new", ProductLive.Index, :new
      live "/:id/edit", ProductLive.Index, :edit
    end
  end

  ## Public LiveView auth routes
  scope "/", EcommerceWeb do
    pipe_through [:browser]

    live_session :current_scope,
      on_mount: [{EcommerceWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  ## Dev-only routes
  if Application.compile_env(:ecommerce, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EcommerceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
