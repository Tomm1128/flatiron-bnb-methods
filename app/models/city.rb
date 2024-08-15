class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin_date, checkout_date)
    listings.where.not(id: Reservation.where("checkin <= ? AND checkout >= ?", checkout_date, checkin_date).select(:listing_id))
  end

  def self.highest_ratio_res_to_listings
    joins(listings: :reservations)
      .select("cities.*, COUNT(reservations.id) / COUNT(DISTINCT listings.id) AS ratio")
      .group("cities.id")
      .order("ratio DESC")
      .first
  end

  def self.most_res
    joins(listings: :reservations)
      .select("cities.*, COUNT(reservations.id) AS total_reservations")
      .group("cities.id")
      .order("total_reservations DESC")
      .first
  end
end
