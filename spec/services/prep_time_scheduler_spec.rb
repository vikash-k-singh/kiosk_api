# spec/services/prep_time_scheduler_spec.rb
require "rails_helper"

RSpec.describe PrepTimeScheduler do
  subject(:scheduler) { described_class.new(Menu, stations: stations) }

  let(:stations) { 2 }

  before do
    allow(Menu).to receive(:find) do |item_id|
      {
        1 => { name: "Burger", price_cents: 999, prep_seconds: 100 },
        2 => { name: "Fries", price_cents: 400, prep_seconds: 200 }
      }[item_id]
    end
  end


  describe "#schedule" do
    subject(:result) { scheduler.schedule(items) }

    context "with multiple items" do
      let(:items) do
        [
          { item_id: 1, qty: 2 }, # 200
          { item_id: 2, qty: 1 }  # 200
        ]
      end

      it "distributes load across stations", :aggregate_failures do
        expect(result.size).to eq(2)

        # total work = 400, should be balanced ~200 each
        times = result.map(&:last)
        expect(times.sum).to eq(400)
        expect(times.max).to be <= 300
      end
    end

    context "with single station" do
      let(:stations) { 1 }
      let(:items) do
        [
          { item_id: 1, qty: 2 }, # 200
          { item_id: 2, qty: 1 }  # 200
        ]
      end

      it "assigns all work to one station" do
        expect(result).to eq([ [ 1, 400 ] ])
      end
    end

    context "when items are empty" do
      let(:items) { [] }

      it "returns zero load for all stations" do
        expect(result).to eq([ [ 1, 0 ], [ 2, 0 ] ])
      end
    end

    context "when there are more stations than items" do
      let(:stations) { 3 }
      let(:items) do
        [ { item_id: 1, qty: 1 }, # 100
          { item_id: 2, qty: 1 }  # 200
        ]
      end

      it "assigns work to two station and leaves others idle" do
        times = result.map(&:last)

        expect(times.sum).to eq(300)
        expect(times.count(0)).to eq(1)
      end
    end

    context "ordering of result" do
      let(:items) do
        [
          { item_id: 1, qty: 3 } # 300
        ]
      end

      it "sorts stations by descending load" do
        expect(result.first.last).to be >= result.last.last
      end
    end

    context "when menu item is missing" do
      let(:items) { [ { item_id: 999, qty: 1 } ] }

      it "raises an error" do
        expect {
          scheduler.schedule(items)
        }.to raise_error(NoMethodError) # current behavior
      end
    end
  end
end
