# frozen_string_literal: true

class Parking::PayService < Parking::BaseService
  def call
    validate_parking
    parking = Parking.parked_and_not_paid(@plate).first

    parking.paid = true
    parking.save!

    success(parking)
  rescue StandardError => e
    failure(e.message)
  end

  private

  def validate_parking
    super

    raise StandardError, "Parking not found" unless Parking.parked?(@plate)
    raise StandardError, "Parking already paid" if Parking.parked_paid?(@plate)
  end
end
