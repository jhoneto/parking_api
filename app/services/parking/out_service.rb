# frozen_string_literal: true

class Parking::OutService < Parking::BaseService
  def call
    validate_parking
    parking = Parking.parked_paid_not_left(@plate).first

    parking.exit_time = Time.current
    parking.save!

    success(parking)
  rescue StandardError => e
    failure(e.message)
  end

  private

  def validate_parking
    super

    raise StandardError, "Parking not found" unless Parking.parked?(@plate)
    raise StandardError, "Need payment to exit" if Parking.outstanding_payment?(@plate)
  end
end
