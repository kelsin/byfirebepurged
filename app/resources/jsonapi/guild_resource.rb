class Jsonapi::GuildResource < JSONAPI::Resource
  attributes :name, :realm, :permission,
             :icon, :icon_color, :border, :border_color, :background_color

  has_many :characters

  # Guilds can't be edited via the API, only reloaded from the wow api
  immutable
end
