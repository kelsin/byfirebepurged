class Raid < ActiveRecord::Base
  belongs_to :account
  has_many :signups
  has_many :characters, :through => :signups

  has_many :permissions, :as => :permissioned

  validates :name, :presence => true
  validates :date, :presence => true
  validates :account, :presence => true

  # By default only deal with raids that are in the future, or under 6 hours
  # past start time.
  default_scope { includes(:permissions).where('date > ?', 6.hours.ago) }

  def self.old
    unscoped { includes(:permissions).where('date <= ?', 6.hours.ago) }
  end

  def admins
    permissions.find_all(&:admin?)
  end

  def members
    permissions.find_all(&:member?)
  end
end
