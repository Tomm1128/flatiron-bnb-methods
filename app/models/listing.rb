class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_validation :set_user_to_host
  after_destroy :revert_user_from_host

  def set_user_to_host
     user = User.find_by(id: host_id)
     if user
      user.host = true
      user.save
     end
  end

  def revert_user_from_host
    user = User.find_by(id: host_id)
    if (user && user.listings.count == 0)
      user.host = false
      user.save
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end

end
