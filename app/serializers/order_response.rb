# app/serializers/order_response.rb
class OrderResponse
  attr_reader :subtotal, :discount, :schedule

  def initialize(subtotal:, discount:, schedule:)
    @subtotal = subtotal
    @discount = discount
    @schedule = schedule
  end

  def to_json(*)
    {
    subtotal_cents: subtotal,
    discount_cents: discount,
    total_cents: total_cents,
    estimated_prep_seconds: estimated_prep_seconds,
    prep_schedule: schedule
  }.freeze
  end

  private

  def total_cents
    subtotal.to_i - discount.to_i
  end

  def estimated_prep_seconds
    schedule&.dig(0, 1)
  end
end
