class Jsonapi::AccountResource < JSONAPI::Resource
  attributes :account_id, :battletag, :permission

  has_many :characters
  has_many :signups
  has_many :raids

  # Accounts can't be edited via the API, only created and updated by logging in
  immutable
end
