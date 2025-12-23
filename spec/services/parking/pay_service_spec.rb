require "rails_helper"

RSpec.describe Parking::PayService, type: :service do
  describe ".call" do
    context "when parking exists and is not paid" do
      let!(:parking) { create(:parking, paid: false) }

      it "returns success result" do
        result = described_class.call(plate: parking.plate)

        expect(result.success?).to be true
      end

      it "marks parking as paid" do
        described_class.call(plate: parking.plate)
        parking.reload

        expect(parking.paid).to be true
      end

      it "returns the parking in data" do
        result = described_class.call(plate: parking.plate)

        expect(result.data).to eq(parking)
      end

      it "persists the changes" do
        described_class.call(plate: parking.plate)
        parking.reload

        expect(parking.paid).to be true
      end
    end

    context "when parking is already paid" do
      let!(:paid_parking) { create(:parking, paid: true) }

      it "returns failure result" do
        result = described_class.call(plate: paid_parking.plate)

        expect(result.failure?).to be true
      end

      it "returns error message" do
        result = described_class.call(plate: paid_parking.plate)

        expect(result.errors).to include("Parking already paid")
      end

      it "does not change paid status" do
        expect {
          described_class.call(plate: paid_parking.plate)
          paid_parking.reload
        }.not_to change(paid_parking, :paid)
      end
    end

    context "when parking does not exist" do
      it "returns failure result" do
        result = described_class.call(plate: "ABC-1234")

        expect(result.failure?).to be true
      end

      it "returns error message" do
        result = described_class.call(plate: "ABC-1234")

        expect(result.errors).to be_present
      end

      it "returns parking not found message" do
        result = described_class.call(plate: "ABC-1234")

        expect(result.error_message).to eq("Parking not found")
      end
    end

    context "when plate is nil" do
      it "returns failure result" do
        result = described_class.call(plate: nil)

        expect(result.failure?).to be true
      end

      it "returns error message" do
        result = described_class.call(plate: nil)

        expect(result.errors).to be_present
      end
    end

    context "when plate is not parked" do
      let!(:parking_with_exit) { create(:parking, :with_exit, paid: false) }

      it "returns failure result" do
        result = described_class.call(plate: parking_with_exit.plate)

        expect(result.failure?).to be true
      end

      it "returns error message" do
        result = described_class.call(plate: parking_with_exit.plate)

        expect(result.errors).to include("Parking not found")
      end

      it "does not change paid status" do
        expect {
          described_class.call(plate: parking_with_exit.plate)
          parking_with_exit.reload
        }.not_to change(parking_with_exit, :paid)
      end
    end

    context "when plate has no outstanding payment" do
      let!(:paid_and_left_parking) { create(:parking, :with_exit, :paid) }

      it "returns failure result" do
        result = described_class.call(plate: paid_and_left_parking.plate)

        expect(result.failure?).to be true
      end

      it "returns error message" do
        result = described_class.call(plate: paid_and_left_parking.plate)

        expect(result.errors).to include("Parking not found")
      end

      it "does not change paid status" do
        expect {
          described_class.call(plate: paid_and_left_parking.plate)
          paid_and_left_parking.reload
        }.not_to change(paid_and_left_parking, :paid)
      end
    end
  end
end
