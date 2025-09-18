defmodule EcommerceWeb.PageController do
  use EcommerceWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
