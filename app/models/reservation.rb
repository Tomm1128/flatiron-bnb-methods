class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :is_guest_host
  validate :check_availability
  validate :checkin_before_checkout
  validate :checkin_and_checkout_not_same

  def duration
    checkout - checkin
  end

  def total_price
    (checkout - checkin) * listing.price
  end

  private

  def is_guest_host
    if guest_id == listing.host_id
      errors.add(:guest, "Guest and host can't be the same user.")
    end
  end

  def check_availability
    overlapping_reservations =
      listing.reservations
             .where.not(id: id)
             .where("checkin < ? AND checkout > ?", checkout, checkin)

    if overlapping_reservations.exists?
      errors.add(:base, "Listing is not available for the selected dates.")
    end
  end

  def checkin_before_checkout
    return unless checkin && checkout
    if checkin >= checkout
      errors.add(:checkin, "must be before checkout.")
    end
  end

  def checkin_and_checkout_not_same
    return unless checkin && checkout
    if checkin == checkout
      errors.add(:base, "Checkin and checkout dates cannot be the same.")
    end
  end
end
