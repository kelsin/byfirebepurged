class Jsonapi::GuildResource < JSONAPI::Resource
  attributes :name, :realm,
             :icon, :icon_color, :border, :border_color, :background_color
  attribute :permission, :delegate => :to_permission

  has_many :characters

  # Guilds can't be edited via the API, only reloaded from the wow api
  immutable
end
