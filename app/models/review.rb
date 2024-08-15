class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :reservation_accepted, :checkout_occured

  def reservation_accepted
    return unless reservation

    if(reservation.status != "accepted")
      errors.add(:reservation, "Reservation is not accepted")
    end
  end

  def checkout_occured
    return unless reservation

    if(reservation.checkout > Date.today)
      errors.add(:reservation, "Check out has not occured")
    end
  end

end
