# frozen_string_literal: true

class PlateFormatValidator
  PLATE_FORMAT = /\A[A-Z]{3}-\d{4}\z/

  def self.valid?(plate)
    return false if plate.blank?

    plate.match?(PLATE_FORMAT)
  end

  def self.validate!(plate)
    unless valid?(plate)
      raise ArgumentError, "Invalid plate format, use AAA-1234"
    end
  end
end
