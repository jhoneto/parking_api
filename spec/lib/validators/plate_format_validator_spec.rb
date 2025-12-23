require "rails_helper"

RSpec.describe PlateFormatValidator do
  describe ".valid?" do
    context "with valid plate format" do
      it "returns true for ABC-1234" do
        expect(described_class.valid?("ABC-1234")).to be true
      end

      it "returns true for XYZ-9999" do
        expect(described_class.valid?("XYZ-9999")).to be true
      end

      it "returns true for AAA-0000" do
        expect(described_class.valid?("AAA-0000")).to be true
      end
    end

    context "with invalid plate format" do
      it "returns false for lowercase letters" do
        expect(described_class.valid?("abc-1234")).to be false
      end

      it "returns false for missing hyphen" do
        expect(described_class.valid?("ABC1234")).to be false
      end

      it "returns false for less than 3 letters" do
        expect(described_class.valid?("AB-1234")).to be false
      end

      it "returns false for more than 3 letters" do
        expect(described_class.valid?("ABCD-1234")).to be false
      end

      it "returns false for less than 4 digits" do
        expect(described_class.valid?("ABC-123")).to be false
      end

      it "returns false for more than 4 digits" do
        expect(described_class.valid?("ABC-12345")).to be false
      end

      it "returns false for blank string" do
        expect(described_class.valid?("")).to be false
      end

      it "returns false for nil" do
        expect(described_class.valid?(nil)).to be false
      end

      it "returns false for random text" do
        expect(described_class.valid?("invalid")).to be false
      end
    end
  end

  describe ".validate!" do
    context "with valid plate" do
      it "does not raise error" do
        expect {
          described_class.validate!("ABC-1234")
        }.not_to raise_error
      end
    end

    context "with invalid plate" do
      it "raises ArgumentError" do
        expect {
          described_class.validate!("invalid")
        }.to raise_error(ArgumentError, "Invalid plate format, use AAA-1234")
      end

      it "raises ArgumentError for nil" do
        expect {
          described_class.validate!(nil)
        }.to raise_error(ArgumentError, "Invalid plate format, use AAA-1234")
      end

      it "raises ArgumentError for blank" do
        expect {
          described_class.validate!("")
        }.to raise_error(ArgumentError, "Invalid plate format, use AAA-1234")
      end
    end
  end
end
