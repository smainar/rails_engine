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
end
