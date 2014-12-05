class Raid < ActiveRecord::Base
  belongs_to :account
  has_many :signups, :inverse_of => :raid

  has_many :permissions, :as => :permissioned

  validates :name, :presence => true
  validates :date, :presence => true
  validates :account, :presence => true

  # By default only deal with raids that are in the future, or under 6 hours
  # past start time.
  default_scope { with_permissions.with_signups.where('date > ?', 6.hours.ago) }

  def self.with_permissions
    includes(:permissions)
  end

  def self.with_signups
    includes(:signups => { :character => :guild })
  end

  def self.old
    unscoped { includes(:permissions).where('date <= ?', 6.hours.ago) }
  end

  def characters
    signups.map(&:character)
  end

  def guilds
    characters.map(&:guild).uniq.sort
  end

  def admins
    permissions.find_all(&:admin?).map(&:key)
  end

  def members
    permissions.find_all(&:member?).map(&:key)
  end
end
