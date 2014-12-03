class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character

  default_scope { includes(:character => :guild) }
end
