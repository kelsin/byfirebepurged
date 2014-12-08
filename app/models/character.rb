class Character < ActiveRecord::Base
  belongs_to :account
  belongs_to :guild

  has_many :signups, :inverse_of => :character
  has_many :raids, :through => :signups

  has_many :class_roles, :primary_key => 'class_id', :foreign_key => 'class_id'
  has_many :roles, :through => :class_roles

  default_scope { includes(:guild) }

  def permissions
    [account.to_permission, to_permission] + (guild ? [guild.to_permission] : [])
  end

  def to_permission
    "Character|#{name}:#{realm}"
  end
end
