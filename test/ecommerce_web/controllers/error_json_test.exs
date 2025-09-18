defmodule EcommerceWeb.ErrorJSONTest do
  use EcommerceWeb.ConnCase, async: true

  test "renders 404" do
    assert EcommerceWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert EcommerceWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
