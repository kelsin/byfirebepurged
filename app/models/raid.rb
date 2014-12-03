class Raid < ActiveRecord::Base
  belongs_to :account
  has_many :signups
  has_many :characters, :through => :signups
end
