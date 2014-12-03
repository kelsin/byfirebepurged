class Account < ActiveRecord::Base
  has_many :characters
  has_many :signups, :through => :characters
  has_many :raids, :through => :signups
  has_many :created_raids, :class_name => 'Raid', :inverse_of => :account

  has_many :sessions

  default_scope { includes(:characters) }

  def guilds
    characters.map(&:guild).compact.uniq.sort
  end

  def signup_for(raid)
    self.signups.find do |signup|
      signup.raid_id == raid.id
    end
  end

  def signed_up?(raid)
    !!signup_for(raid)
  end

  def seated?(raid)
    !!(signup_for(raid).try(:seated?))
  end

  def admin?(raid)
    (permissions & raid.admins.map(&:key)).present?
  end

  def available?(raid)
    (permissions & raid.permissions.map(&:key)).present?
  end

  def creator?(raid)
    self.id == raid.account_id
  end

  def to_permission
    "Account|#{account_id}"
  end

  def available_raids
    @available_raids ||= Raid.where(:permissions => { :key => permissions })
  end

  def permissions
    [to_permission] + characters.map do |c|
      c.to_permission
    end + guilds.map do |g|
      g.to_permission
    end
  end
end
