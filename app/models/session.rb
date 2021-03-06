class Session < ActiveRecord::Base
  belongs_to :account

  # Sessions are only valid for 1 week
  default_scope { where('created_at > ?', 4.weeks.ago) }
end
