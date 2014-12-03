class Character < ActiveRecord::Base
  belongs_to :account
  belongs_to :guild

  has_many :signups, :inverse_of => :character
  has_many :raids, :through => :signups

  default_scope { includes(:guild) }

  def to_permission
    "Character|#{name}:#{realm}"
  end
end
