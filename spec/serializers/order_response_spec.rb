# spec/serializers/order_response_spec.rb
require "rails_helper"

RSpec.describe OrderResponse, type: :serializer do
  describe "#as_json" do
    subject(:response) do
      described_class.new(
        subtotal: subtotal,
        discount: discount,
        schedule: schedule
      ).to_json
    end

    let(:subtotal) { 1000 }
    let(:discount) { 200 }
    let(:schedule) { [ [ 1, 300 ], [ 2, 200 ] ] }

    it "builds the correct response hash" do
      expect(response).to eq(
        subtotal_cents: 1000,
        discount_cents: 200,
        total_cents: 800,
        estimated_prep_seconds: 300,
        prep_schedule: schedule
      )
    end

    context "when schedule is empty" do
      let(:schedule) { [] }

      it "returns nil for estimated_prep_seconds" do
        expect(response[:estimated_prep_seconds]).to be_nil
      end
    end

    context "when schedule is nil" do
      let(:schedule) { nil }

      it "returns nil for estimated_prep_seconds" do
        expect(response[:estimated_prep_seconds]).to be_nil
      end
    end

    context "with nil subtotal and discount" do
      let(:subtotal) { nil }
      let(:discount) { nil }

      it "calculates total safely" do
        expect(response[:total_cents]).to eq(0)
      end
    end
  end
end
