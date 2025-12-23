require "rails_helper"

RSpec.describe Parking::CreateService, type: :service do
  describe ".call" do
    context "with valid plate" do
      let(:plate) { "ABC-1234" }

      it "creates a new parking" do
        expect {
          described_class.call(plate: plate)
        }.to change(Parking, :count).by(1)
      end

      it "returns the created parking" do
        result = described_class.call(plate: plate)

        expect(result.data).to be_a(Parking)
      end

      it "sets the plate" do
        result = described_class.call(plate: plate)

        expect(result.data.plate).to eq(plate)
      end

      it "sets entry_time to current time by default" do
        result = described_class.call(plate: plate)

        expect(result.data.entry_time).to be_present
      end

      it "persists the parking" do
        result = described_class.call(plate: plate)

        expect(result.data.persisted?).to be true
      end
    end

    context "with custom entry_time" do
      let(:plate) { "XYZ-5678" }
      let(:custom_time) { 2.hours.ago }

      it "sets the custom entry_time" do
        result = described_class.call(plate: plate, entry_time: custom_time)

        expect(result.data.entry_time).to eq(custom_time)
      end
    end

    context "with invalid plate" do
      let(:invalid_plate) { "invalid" }

      it "returns failure result" do
        result = described_class.call(plate: invalid_plate)

        expect(result.failure?).to be true
      end

      it "returns error messages" do
        result = described_class.call(plate: invalid_plate)

        expect(result.errors).to be_present
      end

      it "does not create parking" do
        expect {
          described_class.call(plate: invalid_plate)
        }.not_to change(Parking, :count)
      end
    end

    context "with blank plate" do
      it "returns failure result" do
        result = described_class.call(plate: "")

        expect(result.failure?).to be true
      end

      it "returns error messages" do
        result = described_class.call(plate: "")

        expect(result.errors).to be_present
      end
    end

    context "with nil plate" do
      it "returns failure result" do
        result = described_class.call(plate: nil)

        expect(result.failure?).to be true
      end

      it "returns error messages" do
        result = described_class.call(plate: nil)

        expect(result.errors).to be_present
      end
    end
  end
end
