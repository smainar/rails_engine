require "rails_helper"

RSpec.describe "Items API" do
  describe "Record Endpoints" do
    context "Index of Record" do
      it "returns a list of all items" do
        create_list(:item, 5)

        get '/api/v1/items'

        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items.count).to eq(5)
      end
    end

    context "Show Record" do
      it "returns a single item by its id" do
        id = create(:item).id

        get "/api/v1/items/#{id}"

        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["id"]).to eq(id.to_s)
      end
    end

    context "Single Finders" do
      it "returns a single item by data category (attribute) - id" do
        item_1 = create(:item).id
        item_2 = create(:item).id
        item_3 = create(:item).id

        get "/api/v1/items/find?id=#{item_1}"

        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["id"]).to eq(item_1.to_s)
        expect(item["id"]).to_not eq(item_2.to_s)
        expect(item["id"]).to_not eq(item_3.to_s)
      end

      it "returns a single item by data category (attribute) - name" do
        item_1 = create(:item, name: "Stella")
        item_2 = create(:item, name: "Stanley")

        get "/api/v1/items/find?name=#{item_1.name}"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["attributes"]["name"]).to eq(item_1.name)
        expect(item["attributes"]["name"]).to_not eq(item_2.name)

        get "/api/v1/items/find?name=#{item_2.name}"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["attributes"]["name"]).to eq(item_2.name)
        expect(item["attributes"]["name"]).to_not eq(item_1.name)
      end

      it "returns a single item by data category (attribute) - unit price" do
        item_1 = create(:item, unit_price: 100)
        item_2 = create(:item, unit_price: 200)

        get "/api/v1/items/find?unit_price=1.00"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["attributes"]["unit_price"]).to eq(((item_1.unit_price) / 100.0).to_s)
      end

      it "returns a single item by data category (attribute) - merchant id" do
        merchant = create(:merchant)
        item_1 = create(:item, merchant_id: merchant.id)

        get "/api/v1/items/find?merchant_id=#{item_1.merchant_id}"
        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items["attributes"]["id"]).to eq(item_1.id)
        expect(items["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
      end

      it "returns a single item by data category (attribute) - created at" do
        item_1 = create(:item, created_at: "2012-03-27T14:54:02.000Z")
        item_2 = create(:item, created_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/items/find?created_at=#{item_1.created_at}"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["id"]).to eq(item_1.id.to_s)
        expect(item["id"]).to_not eq(item_2.id.to_s)
      end

      it "returns a single item by data category (attribute) - updated at" do
        item_1 = create(:item, updated_at: "2012-03-27T14:54:02.000Z")
        item_2 = create(:item, updated_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/items/find?updated_at=#{item_1.updated_at}"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item["id"]).to eq(item_1.id.to_s)
        expect(item["id"]).to_not eq(item_2.id.to_s)
      end
    end

    context "Multi-Finders" do
      it "returns all matches for the given data category (attribute) - name" do
        item_1 = create(:item, name: "Stella")
        item_2 = create(:item, name: "Stella")
        item_3 = create(:item, name: "Stanley")

        get "/api/v1/items/find_all?name=Stella"
        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["attributes"]["name"]).to eq(item_1.name)
        expect(items[1]["attributes"]["name"]).to eq(item_2.name)
        expect(items.count).to eq(2)

        get "/api/v1/items/find_all?name=Stanley"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item[0]["attributes"]["name"]).to eq(item_3.name)
        expect(item.count).to eq(1)
      end

      it "returns all matches for the given data category (attribute) - unit price" do
        item_1 = create(:item, unit_price: 100)
        item_2 = create(:item, unit_price: 200)

        get "/api/v1/items/find_all?unit_price=#{(item_1.unit_price / 100.0)}"
        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["type"]).to eq("item")
        expect(items[0]["attributes"]["unit_price"]).to eq(((item_1.unit_price) / 100.0).to_s)
      end

      it "returns all matches for the given data category (attribute) - merchant id" do
        merchant = create(:merchant)
        item_1 = create(:item, merchant_id: merchant.id)
        item_2 = create(:item, merchant_id: merchant.id)

        get "/api/v1/items/find_all?merchant_id=#{item_1.merchant_id}"
        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["attributes"]["id"]).to eq(item_1.id)
        expect(items[0]["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
        expect(items[1]["attributes"]["id"]).to eq(item_2.id)
        expect(items[1]["attributes"]["merchant_id"]).to eq(item_2.merchant_id)
      end

      it "returns all matches for the given data category (attribute) - created at" do
        item_1 = create(:item, created_at: "2012-03-27T14:54:02.000Z")
        item_2 = create(:item, created_at: "2012-03-27T14:54:02.000Z")
        item_3 = create(:item, created_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/items/find_all?created_at=#{item_1.created_at}"
        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["attributes"]["id"]).to eq(item_1.id)
        expect(items[1]["attributes"]["id"]).to eq(item_2.id)
        expect(items.count).to eq(2)

        get "/api/v1/items/find_all?created_at=#{item_3.created_at}"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item[0]["attributes"]["id"]).to eq(item_3.id)
        expect(item.count).to eq(1)
      end

      it "returns all matches for the given data category (attribute) - updated at" do
        item_1 = create(:item, updated_at: "2012-03-27T14:54:02.000Z")
        item_2 = create(:item, updated_at: "2012-03-27T14:54:02.000Z")
        item_3 = create(:item, updated_at: "2019-03-27T14:54:02.000Z")

        get "/api/v1/items/find_all?updated_at=#{item_1.updated_at}"
        items = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(items[0]["attributes"]["id"]).to eq(item_1.id)
        expect(items[1]["attributes"]["id"]).to eq(item_2.id)
        expect(items.count).to eq(2)

        get "/api/v1/items/find_all?updated_at=#{item_3.updated_at}"
        item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(item[0]["attributes"]["id"]).to eq(item_3.id)
        expect(item.count).to eq(1)
      end
    end

    context "Random Request URL" do
      it "returns a random resource" do
        create_list(:item, 5)

        get "/api/v1/items/random"

        random_item = JSON.parse(response.body)["data"]

        expect(response).to be_successful
        expect(random_item["type"]).to eq("item")
        expect(random_item.class).to eq(Hash)
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
      it "returns a collection of associated invoice items" do
        get "/api/v1/items/#{@item_1.id}/invoice_items"

        invoice_items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(invoice_items["data"][0]["type"]).to eq("invoice_item")
        expect(invoice_items["data"][0]["attributes"]["item_id"]).to eq(@item_1.id)
        expect(invoice_items["data"][0]["attributes"]["quantity"]).to eq(@invoice_item_1.quantity)
        expect(invoice_items["data"][1]["attributes"]["item_id"]).to eq(@item_1.id)
        expect(invoice_items["data"][1]["attributes"]["quantity"]).to eq(@invoice_item_4.quantity)
        expect(invoice_items["data"].count).to eq(2)
      end

      it "returns the associated merchant" do
        get "/api/v1/items/#{@item_1.id}/merchant"

        merchant = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchant["data"]["type"]).to eq("merchant")
        expect(merchant["data"]["attributes"]["id"]).to eq(@merchant_1.id)

        get "/api/v1/items/#{@item_2.id}/merchant"

        merchant = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchant["data"]["type"]).to eq("merchant")
        expect(merchant["data"]["attributes"]["id"]).to eq(@merchant_2.id)
      end
    end
  end
end
