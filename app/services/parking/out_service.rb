# frozen_string_literal: true

class Parking::OutService < ApplicationService
  def initialize(plate:)
    @plate = plate
  end

  def call
    parking = Parking.find_by(plate: @plate)

    return failure("Exit already registered") if parking.exit_time.present?

    parking.exit_time = Time.current
    parking.save!

    success(parking)
  rescue Mongoid::Errors::DocumentNotFound => e
    failure("Parking not found")
  rescue StandardError => e
    failure(e.message)
  end
end
