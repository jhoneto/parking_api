# frozen_string_literal: true

class Parking::PayService < ApplicationService
  def initialize(plate:)
    @plate = plate
  end

  def call
    parking = Parking.find_by(plate: @plate)

    return failure("Parking already paid") if parking.paid?

    parking.paid = true
    parking.save!

    success(parking)
  rescue Mongoid::Errors::DocumentNotFound => e
    failure("Parking not found")
  rescue StandardError => e
    failure(e.message)
  end
end
