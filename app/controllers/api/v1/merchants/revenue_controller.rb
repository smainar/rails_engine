class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    render json: RevenueSerializer.new(merchant.total_revenue_by_merchant)
  end
end
