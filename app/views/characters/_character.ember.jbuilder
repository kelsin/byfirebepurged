json.extract! character,
              :id, :name, :realm, :class_id, :race_id, :gender_id,
              :level, :item_level, :image_url
json.account character.account_id
json.guild character.guild_id
json.roles character.role_ids
json.permissions character.permissions
