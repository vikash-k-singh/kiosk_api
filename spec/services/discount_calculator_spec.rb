# spec/services/discount_calculator_spec.rb
require "rails_helper"

RSpec.describe DiscountCalculator do
  subject(:calculator) { described_class.new }

  describe "#calculate" do
    context "when subtotal is below threshold" do
      it "returns 0" do
        expect(calculator.calculate(1500)).to eq(0)
      end
    end

    context "when subtotal is equal to threshold" do
      it "applies discount" do
        expect(calculator.calculate(2000)).to eq(200)
      end
    end

    context "when subtotal is above threshold" do
      it "applies discount correctly" do
        expect(calculator.calculate(3000)).to eq(300)
      end
    end
  end
end
