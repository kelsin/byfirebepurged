class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character

  default_scope { includes(:character => :guild) }

  validate :character_must_be_allowed_in_raid
  validates :role, :inclusion => {
              :in => %w(dps healer tank),
              :message => "must be one of 'dps', 'healer', or 'tank'"
            }

  private

  def character_must_be_allowed_in_raid
    unless Permission.check(raid.permissionKeys, character.account.permissions)
      errors.add(:character_id, "is not allowed to attend this raid")
    end
  end
end
