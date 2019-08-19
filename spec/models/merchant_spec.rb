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

  describe "instance methods" do
    before(:each) do
      @customer = create(:customer)

      @merchant_1 = create(:merchant)
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer.id, created_at: "2012-03-27T14:54:02.000Z", updated_at: "2012-03-27T14:54:02.000Z")
      @invoice_item_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, unit_price: 1, quantity: 2)
      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: "success")

      @merchant_2 = create(:merchant)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer.id, created_at: "2012-03-27T14:54:02.000Z", updated_at: "2012-03-27T14:54:02.000Z")
      @invoice_item_2 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id, unit_price: 3, quantity: 4)
      @invoice_item_4 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id, unit_price: 1, quantity: 5)
      @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: "failed")

      @merchant_3 = create(:merchant)
      @item_3 = create(:item, merchant_id: @merchant_3.id)
      @invoice_3 = create(:invoice, merchant_id: @merchant_3.id, customer_id: @customer.id, created_at: "2019-03-27T14:54:02.000Z", updated_at: "2019-03-27T14:54:02.000Z")
      @invoice_item_3 = create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_3.id, unit_price: 5, quantity: 6)
      @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: "success")
    end

    describe "#total_revenue_by_merchant" do
      it "returns the total revenue for that merchant across successful transactions" do
        expect((@merchant_1.total_revenue_by_merchant) / 100.0).to eq(0.02)
      end
    end
  end
end
