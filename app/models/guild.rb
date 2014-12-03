class Guild < ActiveRecord::Base
  has_many :characters
  has_many :accounts, :through => :characters

  validates :name, :presence => true
  validates :realm, :presence => true

  default_scope { distinct }
end
