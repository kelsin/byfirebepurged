class Jsonapi::SignupResource < JSONAPI::Resource
  attributes :note, :preferred, :seated

  has_one :raid
  has_one :character
  has_one :role
  has_many :roles
end
