class Account < ActiveRecord::Base
  has_many :characters
  has_many :sessions
end
