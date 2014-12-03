class Account < ActiveRecord::Base
  has_many :characters
  has_many :guilds, :through => :characters
  has_many :signups, :through => :characters
  has_many :raids, :through => :signups

  has_many :sessions
end
