# app/errors/menu_item_not_found.rb
# Custom error class for handling cases where a menu item is not found in the menu.
# This error is raised by services like Orders::CalculateTotal and PricingCalculator
# when they cannot find a menu item based on the provided item_id.
class MenuItemNotFound < StandardError; end
