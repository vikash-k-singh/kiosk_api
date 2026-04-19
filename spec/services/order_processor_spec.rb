# spec/services/order_processor_spec.rb
require "rails_helper"

RSpec.describe OrderProcessor do
  it "calculates prep schedule correctly" do
    items = [
      { item_id: 1, qty: 2 }, # 180
      { item_id: 2, qty: 2 }, # 120
      { item_id: 3, qty: 1 }  # 75
    ]

    result = described_class.new(items).call

    expect(result[:estimated_prep_seconds]).to eq(195)
    expect(result[:prep_schedule].first[1]).to be >= result[:prep_schedule].last[1]
  end
end
