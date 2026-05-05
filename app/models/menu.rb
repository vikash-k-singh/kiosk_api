# app/models/menu.rb
# Defines the menu items available for order processing.
class Menu
  ITEMS = {
    1 => { name: "Cheeseburger", price_cents: 899, prep_seconds: 90 },
    2 => { name: "Fries",        price_cents: 399, prep_seconds: 60 },
    3 => { name: "Milkshake",    price_cents: 499, prep_seconds: 75 },
    4 => { name: "Salad",        price_cents: 699, prep_seconds: 45 },
    5 => { name: "Nuggets",      price_cents: 599, prep_seconds: 80 }
  }.freeze

  # find item by id.
  def self.find(item_id)
    ITEMS[item_id]
  end

  # check if item exists by id.
  def self.exists?(item_id)
    ITEMS.key?(item_id)
  end
end
