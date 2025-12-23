# frozen_string_literal: true

class Parking::BaseService < ApplicationService
  def initialize(plate:)
    @plate = plate
  end


  private

  def validate_parking
    raise ArgumentError, "Plate is required" if @plate.blank?

    PlateFormatValidator.validate!(@plate)
  end
end
