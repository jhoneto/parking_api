# frozen_string_literal: true


class Parking::CreateService < Parking::BaseService
  def initialize(plate:, entry_time: nil)
    super(plate: plate)
    @entry_time = entry_time || Time.current
  end

  def call
    validate_parking

    parking = Parking.create!(plate: @plate, entry_time: @entry_time)

    success(parking)
  rescue StandardError => e
    failure(e.message)
  end

  private

  def validate_parking
    super
    raise StandardError, "Plate is already parked" if Parking.parked?(@plate)
  end
end
