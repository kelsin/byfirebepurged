class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character
  belongs_to :role
  has_and_belongs_to_many :roles

  before_save :set_role

  default_scope { includes(:character => :guild) }

  validate :character_must_be_allowed_in_raid
  validate :character_must_be_allowed_in_role
  validates :roles, :length => { :minimum => 1 }
  validates :role, :presence => true, :if => Proc.new { |s| s.seated? }

  private

  def set_role
    unless seated
      self.role = nil
    end
  end

  def character_must_be_allowed_in_raid
    unless Permission.check(raid.permissionKeys, character.account.permissions)
      errors.add(:character_id, "is not allowed to attend this raid")
    end
  end

  def character_must_be_allowed_in_role
    unless (self.role_ids - self.character.role_ids).empty?
      errors.add(:character_id, "is not allowed to in those roles")
    end
  end
end
