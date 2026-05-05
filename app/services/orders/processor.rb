# app/services/orders/processor.rb
# Processes a customer order as an Orchestrator,
# delegating to other services for validation,
# pricing, discount calculation, and scheduling.
module Orders
  class Processor
    def initialize(items)
      @items = items
    end

    def call
      validate_items

      subtotal = calculate_subtotal
      discount_amount = calculate_discount(subtotal)
      schedule = schedule_preparation

      build_response(subtotal, discount_amount, schedule)
    end

    private

    attr_reader :items

    def validate_items
      validator.validate!(items)
    end

    def calculate_subtotal
      pricing_calculator.subtotal(items)
    end

    def calculate_discount(subtotal)
      discount_calculator.calculate(subtotal)
    end

    def schedule_preparation
      scheduler.schedule(items)
    end

    def build_response(subtotal, discount, schedule)
      OrderResponse.new(
        subtotal: subtotal,
        discount: discount,
        schedule: schedule
      ).to_json
    end

    def validator
      @validator ||= Orders::Validator.new(Menu)
    end

    def pricing_calculator
      @pricing_calculator ||= Orders::CalculateTotal.new(Menu)
    end

    def discount_calculator
      @discount_calculator ||= DiscountCalculator.new
    end

    def scheduler
      @scheduler ||= PrepTimeScheduler.new(Menu)
    end
  end
end
