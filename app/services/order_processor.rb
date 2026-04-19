# app/services/order_processor.rb
# Processes a customer order.
class OrderProcessor
  def initialize(items)
    @items = items
  end

  def call
    validate(@items)
    subtotal = pricing(@items)
    discount = discount(subtotal)
    schedule = prep_schedule(@items)
    build_response(subtotal, discount, schedule)
  end

  private

  def validate(items)
    validator.validate!(items)
  end

  def pricing(items)
    pricing_calculator.subtotal(items)
  end

  def discount(subtotal)
    discount_calculator.calculate(subtotal)
  end

  def prep_schedule(items)
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
    @validator ||= OrderValidator.new(Menu)
  end

  def pricing_calculator
    @pricing_calculator ||= PricingCalculator.new(Menu)
  end

  def discount_calculator
    @discount_calculator ||= DiscountCalculator.new
  end

  def scheduler
    @scheduler ||= PrepTimeScheduler.new(Menu)
  end
end
