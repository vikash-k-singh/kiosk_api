# app/controllers/api/v1/orders_controller.rb
class Api::V1::OrdersController < ApplicationController
  # Create a new kiosk order
  def create
    result = OrderProcessor.new(items_params).call

    render json: result, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def items_params
    params.require(:items).map do |item|
      item.permit(:item_id, :qty)
    end
  end
end
