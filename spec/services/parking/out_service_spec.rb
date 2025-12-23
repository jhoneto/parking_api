require "rails_helper"

RSpec.describe Parking::OutService, type: :service do
  describe ".call" do
    context "when parking exists and has no exit time" do
      let!(:parking) { create(:parking, exit_time: nil) }

      it "returns success result" do
        result = described_class.call(plate: parking.plate)

        expect(result.success?).to be true
      end

      it "sets exit_time" do
        described_class.call(plate: parking.plate)
        parking.reload

        expect(parking.exit_time).to be_present
      end

      it "sets exit_time close to current time" do
        described_class.call(plate: parking.plate)
        parking.reload

        expect(parking.exit_time.to_i).to be_within(2).of(Time.current.to_i)
      end

      it "returns the parking in data" do
        result = described_class.call(plate: parking.plate)

        expect(result.data).to eq(parking)
      end

      it "persists the changes" do
        described_class.call(plate: parking.plate)
        parking.reload

        expect(parking.exit_time).to be_present
      end
    end

    context "when parking already has exit time" do
      let!(:parking_with_exit) { create(:parking, :with_exit) }

      it "returns failure result" do
        result = described_class.call(plate: parking_with_exit.plate)

        expect(result.failure?).to be true
      end

      it "returns error message" do
        result = described_class.call(plate: parking_with_exit.plate)

        expect(result.errors).to include("Exit already registered")
      end

      it "does not change exit_time" do
        original_exit_time = parking_with_exit.exit_time.change(usec: 0)

        described_class.call(plate: parking_with_exit.plate)
        parking_with_exit.reload

        expect(parking_with_exit.exit_time.change(usec: 0)).to eq(original_exit_time)
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
  end
end
