require "rails_helper"

RSpec.describe "Merchants API" do
  describe "Record Endpoints" do
    context "Index of Record" do
      it "returns a list of all merchants" do
        create_list(:merchant, 5)

        get '/api/v1/merchants'

        merchants = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchants.count).to eq(5)
      end
    end

    context "Show Record" do
      it "returns a single merchant by its id" do
        id = create(:merchant).id

        get "/api/v1/merchants/#{id}"

        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["id"]).to eq(id.to_s)
      end
    end

    context "Single Finders" do
      it "returns a single merchant by data category (attribute) - id" do
        merchant_1 = create(:merchant).id
        merchant_2 = create(:merchant).id
        merchant_3 = create(:merchant).id

        get "/api/v1/merchants/find?id=#{merchant_1}"

        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["id"]).to eq(merchant_1.to_s)
        expect(merchant["id"]).to_not eq(merchant_2.to_s)
        expect(merchant["id"]).to_not eq(merchant_3.to_s)
      end

      it "returns a single merchant by data category (attribute) - name" do
        merchant_1 = create(:merchant, name: "Stella")
        merchant_2 = create(:merchant, name: "Stanley")

        get "/api/v1/merchants/find?name=#{merchant_1.name}"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["attributes"]["name"]).to eq(merchant_1.name)
        expect(merchant["attributes"]["name"]).to_not eq(merchant_2.name)

        get "/api/v1/merchants/find?name=#{merchant_2.name}"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["attributes"]["name"]).to eq(merchant_2.name)
        expect(merchant["attributes"]["name"]).to_not eq(merchant_1.name)
      end

      it "returns a single merchant by data category (attribute) - created at" do
        merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:02.000Z")
        merchant_2 = create(:merchant, created_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/merchants/find?created_at=#{merchant_1.created_at}"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["id"]).to eq(merchant_1.id.to_s)
        expect(merchant["id"]).to_not eq(merchant_2.id.to_s)
      end

      it "returns a single merchant by data category (attribute) - updated at" do
        merchant_1 = create(:merchant, updated_at: "2012-03-27T14:54:02.000Z")
        merchant_2 = create(:merchant, updated_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/merchants/find?updated_at=#{merchant_1.updated_at}"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant["id"]).to eq(merchant_1.id.to_s)
        expect(merchant["id"]).to_not eq(merchant_2.id.to_s)
      end
    end

    context "Multi-Finders" do
      it "returns all matches for the given data category (attribute) - name" do
        merchant_1 = create(:merchant, name: "Stella")
        merchant_2 = create(:merchant, name: "Stella")
        merchant_3 = create(:merchant, name: "Stanley")

        get "/api/v1/merchants/find_all?name=Stella"
        merchants = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchants[0]["attributes"]["name"]).to eq(merchant_1.name)
        expect(merchants[1]["attributes"]["name"]).to eq(merchant_2.name)
        expect(merchants.count).to eq(2)

        get "/api/v1/merchants/find_all?name=Stanley"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant[0]["attributes"]["name"]).to eq(merchant_3.name)
        expect(merchant.count).to eq(1)
      end

      it "returns all matches for the given data category (attribute) - created at" do
        merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:02.000Z")
        merchant_2 = create(:merchant, created_at: "2012-03-27T14:54:02.000Z")
        merchant_3 = create(:merchant, created_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/merchants/find_all?created_at=#{merchant_1.created_at}"
        merchants = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchants[0]["attributes"]["id"]).to eq(merchant_1.id)
        expect(merchants[1]["attributes"]["id"]).to eq(merchant_2.id)
        expect(merchants.count).to eq(2)

        get "/api/v1/merchants/find_all?created_at=#{merchant_3.created_at}"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant[0]["attributes"]["id"]).to eq(merchant_3.id)
        expect(merchant.count).to eq(1)
      end

      it "returns all matches for the given data category (attribute) - updated at" do
        merchant_1 = create(:merchant, updated_at: "2012-03-27T14:54:02.000Z")
        merchant_2 = create(:merchant, updated_at: "2012-03-27T14:54:02.000Z")
        merchant_3 = create(:merchant, updated_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/merchants/find_all?updated_at=#{merchant_1.updated_at}"
        merchants = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchants[0]["attributes"]["id"]).to eq(merchant_1.id)
        expect(merchants[1]["attributes"]["id"]).to eq(merchant_2.id)
        expect(merchants.count).to eq(2)

        get "/api/v1/merchants/find_all?updated_at=#{merchant_3.updated_at}"
        merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(merchant[0]["attributes"]["id"]).to eq(merchant_3.id)
        expect(merchant.count).to eq(1)
      end
    end

    context "Random Request URL" do
      it "returns a random resource" do
        create_list(:merchant, 5)

        get "/api/v1/merchants/random"

        random_merchant = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(random_merchant["type"]).to eq("merchant")
        expect(random_merchant.class).to eq(Hash)
      end
    end
  end

  describe "Relationship Endpoints" do
    context "Nested URLs" do
      it "returns a collection of items associated with that merchant" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)

        merchant_2 = create(:merchant)
        item_3 = create(:item, merchant: merchant_2)

        get "/api/v1/merchants/#{merchant_1.id}/items"

        merchant_items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchant_items["data"][0]["type"]).to eq("item")
        expect(merchant_items["data"][0]["attributes"]["merchant_id"]).to eq(merchant_1.id)
        expect(merchant_items["data"][0]["attributes"]["merchant_id"]).to eq(merchant_1.id)
        expect(merchant_items["data"].count).to eq(2)
      end

      it "returns a collection of invoices associated with that merchant from their known orders" do
        merchant_1 = create(:merchant)
        invoice_1 = create(:invoice, merchant: merchant_1)
        invoice_2 = create(:invoice, merchant: merchant_1)

        merchant_2 = create(:merchant)
        invoice_3 = create(:invoice, merchant: merchant_2)

        get "/api/v1/merchants/#{merchant_1.id}/invoices"

        merchant_invoices = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchant_invoices["data"][0]["type"]).to eq("invoice")
        expect(merchant_invoices["data"][0]["attributes"]["merchant_id"]).to eq(merchant_1.id)
        expect(merchant_invoices["data"][0]["attributes"]["merchant_id"]).to eq(merchant_1.id)
        expect(merchant_invoices["data"].count).to eq(2)
      end
    end
  end

  describe "Business Intelligence Endpoints" do
    context "ActiveRecord Queries - All Merchants" do
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

      it "returns the top x merchants ranked by total revenue" do
        get "/api/v1/merchants/most_revenue?quantity=2"

        top_merchants_by_revenue = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(top_merchants_by_revenue.count).to eq(2)
        expect(top_merchants_by_revenue[0]["id"]).to eq(@merchant_3.id.to_s)
        expect(top_merchants_by_revenue[1]["id"]).to eq(@merchant_1.id.to_s)
      end

      it "returns the top x merchants ranked by total number of items sold" do
        get "/api/v1/merchants/most_items?quantity=2"

        top_merchants_by_items_sold = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(top_merchants_by_items_sold.count).to eq(2)
        expect(top_merchants_by_items_sold[0]["id"]).to eq(@merchant_3.id.to_s)
        expect(top_merchants_by_items_sold[1]["id"]).to eq(@merchant_1.id.to_s)
      end
    end

    context "ActiveRecord Queries - Single Merchant" do
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

      it "returns the total revenue for that merchant across successful transactions" do
        get "/api/v1/merchants/#{@merchant_1.id}/revenue"

        total_revenue_by_merchant = JSON.parse(response.body)["data"]
        
        expect(response).to be_successful
        expect(total_revenue_by_merchant["attributes"]["revenue"]).to eq("2.0")
      end
    end
  end
end
