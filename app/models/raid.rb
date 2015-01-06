class Raid < ActiveRecord::Base
  belongs_to :account
  belongs_to :guild
  has_many :signups, :inverse_of => :raid

  has_many :permissions, :as => :permissioned

  validates :name, :presence => true
  validates :date, :presence => true
  validates :account, :presence => true
  validates :requiredLevel, :numericality => {
              :only_integer => true,
              :greater_than => 0,
              :allow_nil => true
            }
  validates :requiredItemLevel, :numericality => {
              :only_integer => true,
              :greater_than => 0,
              :allow_nil => true
            }

  def self.current
    where('date > ?', 6.hours.ago)
  end

  def self.with_permissions
    includes(:permissions)
  end

  def self.with_signups
    includes(:signups => { :character => :guild })
  end

  def self.with_account
    includes(:account)
  end

  def self.for_permissions(permissions)
    joins("JOIN permissions as p ON p.permissioned_id = raids.id AND p.permissioned_type = 'Raid'")
      .where('lower(p.key) in (?)', permissions.map(&:downcase))
  end

  def self.old
    unscoped { includes(:permissions).where('date <= ?', 6.hours.ago) }
  end

  def characters
    signups.map(&:character)
  end

  def accounts
    (characters.map(&:account) + [self.account]).sort.uniq
  end

  def guilds
    ([self.guild] + characters.map(&:guild)).uniq.compact.sort
  end

  def permissionKeys
    permissions.map(&:key)
  end

  def admins
    permissions.find_all(&:admin?).map(&:key)
  end

  def members
    permissions.find_all(&:member?).map(&:key)
  end
end
