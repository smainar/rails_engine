class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    top_merchants_by_items_sold = Merchant.ranked_by_most_items_sold(params[:quantity])
    render json: MerchantSerializer.new(top_merchants_by_items_sold)
  end
end
