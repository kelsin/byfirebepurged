class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character

  default_scope { includes(:character => :guild) }

  validate :character_must_be_allowed_in_raid

  private

  def character_must_be_allowed_in_raid
    unless Permission.check(raid.permissionKeys, character.permissions)
      errors.add(:character_id, "can't be greater than total value")
    end
  end
end
