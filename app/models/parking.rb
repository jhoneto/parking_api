class Parking
  include Mongoid::Document
  include Mongoid::Timestamps

  field :plate, type: String
  field :entry_time, type: DateTime
  field :exit_time, type: DateTime
  field :paid, type: Boolean, default: false

  validates :plate, presence: true, format: { with: /\A[A-Z]{3}-\d{4}\z/, message: "invalid format, use AAA-1234" }
  validates :entry_time, presence: true

  scope :parked, ->(plate) { where(plate: plate, exit_time: nil) }
  scope :parked_and_not_paid, ->(plate) { where(plate: plate, paid: false, exit_time: nil) }
  scope :parked_paid_not_left, ->(plate) { where(plate: plate, paid: true, exit_time: nil) }

  def self.parked?(plate)
    parked(plate).exists?
  end

  def self.outstanding_payment?(plate)
    parked_and_not_paid(plate).exists?
  end

  def self.parked_paid?(plate)
    parked_paid_not_left(plate).exists?
  end
end
