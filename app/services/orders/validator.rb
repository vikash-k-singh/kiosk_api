# app/services/orders/validator.rb
module Orders
  class Validator
    def initialize(menu)
      @menu = menu
    end

    def validate!(items)
      raise_error("Items missing") if items.blank?
      items.each do |item|
        validate_item!(item)
      end
    end

    private

    attr_reader :menu

    def validate_item!(item)
      raise_error("Invalid qty") unless valid_qty?(item[:qty])
      raise_error("Invalid item_id") unless menu.exists?(item[:item_id])
    end

    def valid_qty?(qty)
      qty.is_a?(Integer) && qty.positive?
    end

    def raise_error(msg)
      raise StandardError, msg
    end
  end
end
