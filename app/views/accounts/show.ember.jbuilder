json.ignore_nil! true

json.account do
  json.partial! 'accounts/account', :account => @account
  json.characters @account.character_ids
end

json.characters @account.characters do |character|
  json.partial! 'characters/character', :character => character
end

json.guilds @account.guilds do |guild|
  json.partial! 'guilds/guild', :guild => guild
end

json.roles roles, :partial => 'roles/role', :as => :role
json.permissions @account.permissions
