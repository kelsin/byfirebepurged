class Login < ActiveRecord::Base
  # Logins are only valid for 5 minutes
  default_scope { where('created_at > ?', 5.minutes.ago) }
end
