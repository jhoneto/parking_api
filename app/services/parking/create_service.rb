# frozen_string_literal: true


class Parking::CreateService < ApplicationService
  def initialize(plate:, entry_time: nil)
    @plate = plate
    @entry_time = entry_time || Time.current
  end

  def call
    parking = Parking.create!(plate: @plate, entry_time: @entry_time)

    success(parking)
  rescue StandardError => e
    failure(e.message)
  end
end
