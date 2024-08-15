class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin_date, checkout_date)
    listings.where.not(id: Reservation.where("checkin <= ? AND checkout >= ?", checkout_date, checkin_date).select(:listing_id))
  end

  def self.highest_ratio_res_to_listings
    joins(listings: :reservations)
      .select("neighborhoods.*, COUNT(reservations.id) / COUNT(DISTINCT listings.id) AS ratio")
      .group("neighborhoods.id")
      .order("ratio DESC")
      .first
  end

  def self.most_res
    joins(listings: :reservations)
      .select("neighborhoods.*, COUNT(reservations.id) AS total_reservations")
      .group("neighborhoods.id")
      .order("total_reservations DESC")
      .first
  end
end
