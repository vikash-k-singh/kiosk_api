# app/services/pricing_calculator.rb
class PricingCalculator
  def initialize(menu)
    @menu = menu
  end

  def subtotal(items)
    items.sum do |item|
      menu_item = @menu.find(item[:item_id])
      raise "Menu item not found: #{item[:item_id]}" unless menu_item

      menu_item[:price_cents] * item[:qty]
    end
  end
end
