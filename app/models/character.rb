class Character < ActiveRecord::Base
  belongs_to :account
  belongs_to :guild

  has_many :signups
  has_many :raids, :through => :signups
end
