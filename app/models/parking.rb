class Parking
  include Mongoid::Document
  include Mongoid::Timestamps

  field :plate, type: String
  field :entry_time, type: DateTime
  field :exit_time, type: DateTime
  field :paid, type: Boolean, default: false

  validates :plate, presence: true, format: { with: /\A[A-Z]{3}-\d{4}\z/, message: "invalid format, use AAA-1234" }
  validates :entry_time, presence: true

  def self.parked?(plate)
    where(plate: plate, exit_time: nil).exists?
  end

  def self.outstanding_payment?(plate)
    where(plate: plate, paid: false, exit_time: nil).exists?
  end
end
