# app/services/orders/calculate_total.rb
# Calculates the subtotal for an order based on the menu prices and item quantities.
# This service is used by the Orders::Processor to compute the total cost before discounts.
module Orders
  class CalculateTotal
    attr_reader :menu

    def initialize(menu)
      @menu = menu
    end

    def subtotal(items)
      items.sum do |item|
        menu_item = find_menu_item(item[:item_id])

        menu_item[:price_cents] * item[:qty]
      end
    end

    private

    def find_menu_item(item_id)
      menu.find(item_id) ||
        raise(MenuItemNotFound, "Menu item not found: #{item_id}")
    end
  end
end
