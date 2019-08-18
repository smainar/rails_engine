class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    top_merchants_by_revenue = Merchant.ranked_by_most_revenue(params[:quantity])
    render json: MerchantSerializer.new(top_merchants_by_revenue)
  end
end
