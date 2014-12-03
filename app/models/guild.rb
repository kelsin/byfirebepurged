class Guild < ActiveRecord::Base
  has_many :characters
  has_many :accounts, :through => :characters
end
