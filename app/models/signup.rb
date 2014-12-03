class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character
end
