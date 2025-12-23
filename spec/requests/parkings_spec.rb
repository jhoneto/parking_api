require "rails_helper"

RSpec.describe "Parkings", type: :request do
  describe "POST /parking" do
    let(:valid_params) do
      {
        parking: {
          plate: "ABC-1234"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new parking" do
        expect {
          post "/parking", params: valid_params, headers: valid_auth_headers, as: :json
        }.to change(Parking, :count).by(1)
      end

      it "returns created status" do
        post "/parking", params: valid_params, headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:created)
      end

      it "returns parking id" do
        post "/parking", params: valid_params, headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["id"]).to be_present
      end

      it "sets entry_time automatically" do
        post "/parking", params: valid_params, headers: valid_auth_headers, as: :json
        parking = Parking.last

        expect(parking.entry_time).to be_present
      end
    end

    context "with invalid plate format" do
      let(:invalid_params) do
        {
          parking: {
            plate: "invalid"
          }
        }
      end

      it "does not create a new parking" do
        expect {
          post "/parking", params: invalid_params, headers: valid_auth_headers, as: :json
        }.not_to change(Parking, :count)
      end

      it "returns unprocessable entity status" do
        post "/parking", params: invalid_params, headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        post "/parking", params: invalid_params, headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to be_present
      end
    end

    context "without plate parameter" do
      let(:empty_params) do
        {
          parking: {
            plate: ""
          }
        }
      end

      it "returns unprocessable entity status" do
        post "/parking", params: empty_params, headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        post "/parking", params: empty_params, headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to be_present
      end
    end
  end

  describe "GET /parking/:id" do
    context "when parking exists" do
      let!(:parking) { create(:parking, entry_time: 30.minutes.ago) }

      it "returns ok status" do
        get "/parking/#{parking.plate}", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:ok)
      end

      it "returns parking data" do
        get "/parking/#{parking.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response).to be_an(Array)
      end

      it "returns parking id" do
        get "/parking/#{parking.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.first["id"]).to eq(parking.id.to_s)
      end

      it "returns time in minutes format" do
        get "/parking/#{parking.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.first["time"]).to match(/\d+ minutes/)
      end

      it "returns paid status" do
        get "/parking/#{parking.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.first["paid"]).to eq(parking.paid)
      end

      it "returns left status" do
        get "/parking/#{parking.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.first["left"]).to eq(false)
      end
    end

    context "when parking has exit time" do
      let!(:parking_with_exit) { create(:parking, :with_exit) }

      it "returns left as true" do
        get "/parking/#{parking_with_exit.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.first["left"]).to eq(true)
      end
    end

    context "when multiple parkings exist for same plate" do
      let!(:parking1) { create(:parking, entry_time: 2.hours.ago) }
      let!(:parking2) { create(:parking, plate: parking1.plate, entry_time: 1.hour.ago) }

      it "returns all parkings for the plate" do
        get "/parking/#{parking1.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.size).to eq(2)
      end

      it "returns parkings ordered by entry_time desc" do
        get "/parking/#{parking1.plate}", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response.first["id"]).to eq(parking2.id.to_s)
      end
    end

    context "when no parking exists for plate" do
      it "returns empty array" do
        get "/parking/ABC-9999", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response).to eq([])
      end
    end
  end

  describe "PUT /parking/:id/out" do
    let!(:parking) { create(:parking, paid: true) }

    context "when parking exists and has no exit time" do
      it "returns ok status" do
        put "/parking/#{parking.plate}/out", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:ok)
      end

      it "updates exit_time" do
        put "/parking/#{parking.plate}/out", headers: valid_auth_headers, as: :json
        parking.reload

        expect(parking.exit_time).to be_present
      end

      it "does not return body" do
        put "/parking/#{parking.plate}/out", headers: valid_auth_headers, as: :json

        expect(response.body).to be_empty
      end
    end

    context "when parking already has exit time" do
      let!(:parking_with_exit) { create(:parking, :with_exit) }

      it "returns unprocessable entity status" do
        put "/parking/#{parking_with_exit.plate}/out", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        put "/parking/#{parking_with_exit.plate}/out", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Parking not found")
      end
    end

    context "when parking does not exist" do
      it "returns unprocessable entity status" do
        put "/parking/ABC-9999/out", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        put "/parking/ABC-9999/out", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Parking not found")
      end
    end
  end

  describe "PUT /parking/:id/pay" do
    let!(:parking) { create(:parking) }

    context "when parking exists and is not paid" do
      it "returns ok status" do
        put "/parking/#{parking.plate}/pay", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:ok)
      end

      it "marks parking as paid" do
        put "/parking/#{parking.plate}/pay", headers: valid_auth_headers, as: :json
        parking.reload

        expect(parking.paid).to be true
      end

      it "does not return body" do
        put "/parking/#{parking.plate}/pay", headers: valid_auth_headers, as: :json

        expect(response.body).to be_empty
      end
    end

    context "when parking is already paid" do
      let!(:paid_parking) { create(:parking, paid: true) }

      it "returns unprocessable entity status" do
        put "/parking/#{paid_parking.plate}/pay", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        put "/parking/#{paid_parking.plate}/pay", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Parking already paid")
      end
    end

    context "when parking does not exist" do
      it "returns unprocessable entity status" do
        put "/parking/ABC-9999/pay", headers: valid_auth_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        put "/parking/ABC-9999/pay", headers: valid_auth_headers, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Parking not found")
      end
    end
  end
end
