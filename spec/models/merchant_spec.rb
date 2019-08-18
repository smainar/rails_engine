require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe "class methods" do
    before(:each) do
      @customer = create(:customer)

      @merchant_1 = create(:merchant)
      @item_1 = create(:item, merchant: @merchant_1)
      @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer)
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 1, quantity: 2)
      @transaction_1 = create(:transaction, invoice: @invoice_1, result: "success")

      @merchant_2 = create(:merchant)
      @item_2 = create(:item, merchant: @merchant_2)
      @invoice_2 = create(:invoice, merchant: @merchant_2, customer: @customer)
      @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2, unit_price: 3, quantity: 4)
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: "failed")

      @merchant_3 = create(:merchant)
      @item_3 = create(:item, merchant: @merchant_3)
      @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer)
      @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3, unit_price: 5, quantity: 6)
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: "success")
    end

    describe "#ranked_by_most_revenue" do
      it "returns the top x merchants ranked by total revenue" do
        expect(Merchant.ranked_by_most_revenue(1)).to eq([@merchant_3])
        expect(Merchant.ranked_by_most_revenue(2)).to eq([@merchant_3, @merchant_1])
      end
    end

    describe "#ranked_by_most_items_sold" do
      it "returns the top x merchants ranked by total number of items sold" do
        expect(Merchant.ranked_by_most_items_sold(1)).to eq([@merchant_3])
        expect(Merchant.ranked_by_most_items_sold(2)).to eq([@merchant_3, @merchant_1])
      end
    end
  end
end
