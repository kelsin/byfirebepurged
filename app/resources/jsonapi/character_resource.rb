class Jsonapi::CharacterResource < JSONAPI::Resource
  attributes :name, :realm, :class_id, :race_id, :gender_id,
             :level, :item_level,
             :image_url, :created_at, :updated_at
  attribute :permission, :delegate => :to_permission

  has_one :account
  has_one :guild
  has_many :signups
  has_many :roles

  # Characters can't be edited via the API, only reloaded from the wow api
  immutable
end
