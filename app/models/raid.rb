class Raid < ActiveRecord::Base
  belongs_to :account
  has_many :signups
  has_many :characters, :through => :signups

  # By default only deal with raids that are in the future, or under 6 hours
  # past start time.
  default_scope { where('date > ?', 6.hours.ago) }
end
