json.ignore_nil! true

json.account do
  json.extract! @account, :id, :account_id, :battletag
  json.characters @account.character_ids
end

json.characters @account.characters do |character|
  json.extract! character,
                :id, :name, :realm, :class_id, :race_id, :gender_id,
                :level, :item_level, :image_url
  json.guild character.guild_id
end

json.guilds @account.guilds do |guild|
  json.extract! guild, :id, :name, :realm
end
