class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations

  def hosts
    listing_ids = trips.pluck(:listing_id)
    host_ids = Listing.where(id: listing_ids).pluck(:host_id).uniq
    User.where(id: host_ids)
  end

  def host_reviews
    listing_ids = listings.pluck(:id)
    reservations_ids = reservations.where(listing_id: listing_ids).pluck(:id)
    Review.where(reservation_id: reservation_ids)
  end

end
