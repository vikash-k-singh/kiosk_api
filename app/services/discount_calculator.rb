# app/services/discount_calculator.rb
class DiscountCalculator
  THRESHOLD = 2000
  RATE = 0.10

  def calculate(subtotal)
    return 0 if subtotal < THRESHOLD
    (subtotal * RATE).round
  end
end
