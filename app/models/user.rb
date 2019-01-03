class User < ApplicationRecord
  has_many :events_guests, foreign_key: 'guest_id'
  has_many :events, through: :events_guests
  has_many :events, foreign_key: 'host_id'
  has_many :interests, through: :events
  has_many :guests, class_name: 'EventsGuest', foreign_key: 'guest_id'

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :age, presence: true
  validates :password, length: {minimum: 6}
  validate :user_has_enough_points

  def user_has_enough_points
    if self.points < 100
      errors.add("You don't have enough points!")
    end
  end

  def add_points
    self.update_attribute(:points, 100)
  end

  def events_user_is_attending
    eventsguests = EventsGuest.all.select {|x| x.guest_id == self.id }
    eventsguests.collect {|x| x.event }
  end
end
