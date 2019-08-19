require "rails_helper"

RSpec.describe "Invoices API" do
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
    @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: "failed")

    @merchant_3 = create(:merchant)
    @item_3 = create(:item, merchant_id: @merchant_3.id)
    @invoice_3 = create(:invoice, merchant_id: @merchant_3.id, customer_id: @customer.id, created_at: "2019-03-27T14:54:02.000Z", updated_at: "2019-03-27T14:54:02.000Z")
    @invoice_item_3 = create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_3.id, unit_price: 5, quantity: 6)
    @invoice_item_4 = create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_1.id, unit_price: 1, quantity: 5)
    @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: "success")
  end

  describe "Record Endpoints" do
    context "Index of Record" do
      it "returns a list of all invoices" do
        get '/api/v1/invoices'

        invoices = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoices.count).to eq(3)
      end
    end

    context "Show Record" do
      it "returns a single invoice by its id" do
        get "/api/v1/invoices/#{@invoice_1.id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["id"]).to eq(@invoice_1.id.to_s)
      end
    end

    context "Single Finders" do
      it "returns a single invoice by data category (attribute) - id" do
        get "/api/v1/invoices/find?id=#{@invoice_1.id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["attributes"]["id"]).to eq(@invoice_1.id)
        expect(invoice["attributes"]["id"]).to_not eq(@invoice_2.id)
        expect(invoice["attributes"]["id"]).to_not eq(@invoice_3.id)
      end

      it "returns a single invoice by data category (attribute) - customer id" do
        get "/api/v1/invoices/find?customer_id=#{@invoice_1.customer_id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["attributes"]["customer_id"]).to eq(@invoice_1.customer_id)
      end

      it "returns a single invoice by data category (attribute) - merchant id" do
        get "/api/v1/invoices/find?merchant_id=#{@invoice_1.merchant_id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["attributes"]["merchant_id"]).to eq(@invoice_1.merchant_id)
      end

      it "returns a single invoice by data category (attribute) - status" do
        get "/api/v1/invoices/find?status=#{@invoice_1.status}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["attributes"]["id"]).to eq(@invoice_1.id)
        expect(invoice["attributes"]["status"]).to eq(@invoice_1.status)
      end

      it "returns a single invoice by data category (attribute) - created at" do
        get "/api/v1/invoices/find?created_at=#{@invoice_1.created_at}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["attributes"]["id"]).to eq(@invoice_1.id)
      end

      it "returns a single invoice by data category (attribute) - updated at" do
        get "/api/v1/invoices/find?updated_at=#{@invoice_1.updated_at}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice["attributes"]["id"]).to eq(@invoice_1.id)
      end
    end

    context "Multi-Finders" do
      it "returns all matches for the given data category (attribute) - id" do
        get "/api/v1/invoices/find_all?id=#{@invoice_1.id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice[0]["attributes"]["id"]).to eq(@invoice_1.id)
        expect(invoice[0]["attributes"]["id"]).to_not eq(@invoice_2.id)
        expect(invoice[0]["attributes"]["id"]).to_not eq(@invoice_3.id)
      end

      it "returns all matches for the given data category (attribute) - customer id" do
        get "/api/v1/invoices/find_all?customer_id=#{@invoice_1.customer_id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice[0]["attributes"]["customer_id"]).to eq(@invoice_1.customer_id)
      end

      it "returns all matches for the given data category (attribute) - merchant id" do
        get "/api/v1/invoices/find_all?merchant_id=#{@invoice_1.merchant_id}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice[0]["attributes"]["merchant_id"]).to eq(@invoice_1.merchant_id)
      end

      it "returns all matches for the given data category (attribute) - status" do
        get "/api/v1/invoices/find_all?status=#{@invoice_1.status}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice[0]["attributes"]["id"]).to eq(@invoice_1.id)
        expect(invoice[0]["attributes"]["status"]).to eq(@invoice_1.status)
      end

      it "returns all matches for the given data category (attribute) - created at" do
        get "/api/v1/invoices/find_all?created_at=#{@invoice_1.created_at}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice[0]["attributes"]["id"]).to eq(@invoice_1.id)
        expect(invoice[1]["attributes"]["id"]).to eq(@invoice_2.id)
      end

      it "returns all matches for the given data category (attribute) - updated at" do
        get "/api/v1/invoices/find_all?updated_at=#{@invoice_1.updated_at}"

        invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(invoice[0]["attributes"]["id"]).to eq(@invoice_1.id)
        expect(invoice[1]["attributes"]["id"]).to eq(@invoice_2.id)
      end
    end

    context "Random Request URL" do
      it "returns a random resource" do
        get "/api/v1/invoices/random"

        random_invoice = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(random_invoice["type"]).to eq("invoice")
        expect(random_invoice.class).to eq(Hash)
      end
    end
  end

  describe "Relationship Endpoints" do
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
      @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_1, unit_price: 1, quantity: 5)
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: "success")
    end

    context "Nested URLs" do
      it "returns a collection of associated transactions" do
        get "/api/v1/invoices/#{@invoice_1.id}/transactions"

        transactions = JSON.parse(response.body)

        expect(response).to be_successful
        expect(transactions["data"][0]["type"]).to eq("transaction")
        expect(transactions["data"][0]["attributes"]["invoice_id"]).to eq(@invoice_1.id)
        expect(transactions["data"].count).to eq(1)
      end

      it "returns a collection of associated invoice items" do
        get "/api/v1/invoices/#{@invoice_1.id}/invoice_items"

        invoice_items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(invoice_items["data"][0]["type"]).to eq("invoice_item")
        expect(invoice_items["data"][0]["attributes"]["invoice_id"]).to eq(@invoice_1.id)
        expect(invoice_items["data"].count).to eq(1)
      end

      it "returns a collection of associated items" do
        get "/api/v1/invoices/#{@invoice_1.id}/items"

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"][0]["type"]).to eq("item")
        expect(items["data"][0]["attributes"]["id"]).to eq(@item_1.id)
        expect(items["data"][0]["attributes"]["name"]).to eq(@item_1.name)
        expect(items["data"].count).to eq(1)
      end

      it "returns the associated customer" do
        get "/api/v1/invoices/#{@invoice_1.id}/customer"

        customer = JSON.parse(response.body)

        expect(response).to be_successful
        expect(customer["data"]["type"]).to eq("customer")
        expect(customer["data"]["attributes"]["id"]).to eq(@customer.id)
        expect(customer["data"]["attributes"]["last_name"]).to eq(@customer.last_name)
        expect(customer.count).to eq(1)
      end

      it "returns the associated merchant" do
        get "/api/v1/invoices/#{@invoice_1.id}/merchant"

        merchant = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchant["data"]["type"]).to eq("merchant")
        expect(merchant["data"]["attributes"]["id"]).to eq(@merchant_1.id)
        expect(merchant["data"]["attributes"]["name"]).to eq(@merchant_1.name)
        expect(merchant.count).to eq(1)
      end
    end
  end
end
