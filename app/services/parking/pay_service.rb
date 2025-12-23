# frozen_string_literal: true

class Parking::PayService < Parking::BaseService
  def call
    validate_parking
    parking = Parking.where(plate: @plate).first

    parking.paid = true
    parking.save!

    success(parking)
  rescue StandardError => e
    failure(e.message)
  end

  private

  def validate_parking
    super

    parking = Parking.where(plate: @plate).first
    raise StandardError, "Parking not found" if parking.nil?
    raise StandardError, "Plate is not parked" if parking.exit_time.present?
    raise StandardError, "Parking already paid" if parking.paid?
  end
end
