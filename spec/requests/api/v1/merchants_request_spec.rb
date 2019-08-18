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
end
