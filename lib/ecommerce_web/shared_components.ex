defmodule EcommerceWeb.SharedComponents do
  use Phoenix.Component

  def button(assigns) do
    ~H"""
    <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
      {render_slot(@inner_block)}
    </button>
    """
  end

  def card(assigns) do
    ~H"""
    <div class="border rounded p-4 shadow">
      {render_slot(@inner_block)}
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div class="mb-4">
      <label class="block text-sm font-bold mb-2">{@label}</label>
      <input
        type={@type || "text"}
        name={@field.name}
        value={Phoenix.HTML.Form.input_value(@field.form, @field.field)}
        class="border rounded w-full py-2 px-3"
      />
      <%= if error = List.first(@field.errors) do %>
        <p class="text-red-500 text-xs italic">{error}</p>
      <% end %>
    </div>
    """
  end
end
