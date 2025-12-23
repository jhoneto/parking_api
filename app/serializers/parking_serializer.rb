# frozen_string_literal: true

class ParkingSerializer
  def initialize(parking)
    @parking = parking
  end

  def as_json
    {
      id: @parking.id.to_s,
      time: formatted_time,
      paid: @parking.paid,
      left: @parking.exit_time.present?
    }
  end

  private

  def formatted_time
    time_in_seconds = (@parking.exit_time || Time.current) - @parking.entry_time
    time_in_minutes = (time_in_seconds / 60).round
    "#{time_in_minutes} minutes"
  end
end
