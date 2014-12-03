json.ignore_nil! true

json.account do
  json.extract! @account, :id, :account_id, :battletag
  json.characters @account.character_ids
end

json.characters @account.characters do |character|
  json.partial! 'characters/character', :character => character
end

json.guilds @account.guilds do |guild|
  json.partial! 'guilds/guild', :guild => guild
end
