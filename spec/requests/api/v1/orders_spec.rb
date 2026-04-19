require "rails_helper"

RSpec.describe "Api::V1::Orders", type: :request do
  it "creates order successfully" do
    post "/api/v1/orders", params: {
      items: [
        { item_id: 1, qty: 2 },
        { item_id: 2, qty: 1 },
        { item_id: 3, qty: 2 },
        { item_id: 4, qty: 1 }

      ]
    }.to_json, headers: { "CONTENT_TYPE" => "application/json" }

    result = JSON.parse(response.body)

    # puts "Response: #{response.body}"

    expect(response).to have_http_status(:ok)
    expect(result["subtotal_cents"]).to be > 0
    expect(result["prep_schedule"][0][1]).to be >= result["prep_schedule"][1][1]
  end


  it "fails to create order with invalid item" do
    post "/api/v1/orders", params: {
      items: [
        { item_id: 1, qty: "2" },
        { item_id: 2, qty: "1" },
        { item_id: 3, qty: "2" },
        { item_id: 4, qty: "1" }
      ]
    }.to_json, headers: { "CONTENT_TYPE" => "application/json" }

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:bad_request)
    expect(result["error"]).to eq("Invalid qty")
  end

  it "returns 400 for invalid item" do
    items = [ { item_id: 99, qty: 0 }, { item_id: 99, qty: '1' }, { item_id: 2, qty: -1 } ]
    items.shuffle!

    post "/api/v1/orders", params: {
      items: [ items.pop ]
    }.to_json, headers: { "CONTENT_TYPE" => "application/json" }

    expect(response).to have_http_status(:bad_request)
  end
end
