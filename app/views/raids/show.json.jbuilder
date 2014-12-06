json.raid do
  json.partial! 'raids/raid', :raid => @raid
  json.permissions @raid.permission_ids if can? :manage, @raid
end

json.accounts [@raid.account], :partial => 'accounts/account', :as => :account
json.signups @raid.signups, :partial => 'signups/signup', :as => :signup
json.characters @raid.characters, :partial => 'characters/character', :as => :character
json.guilds @raid.guilds, :partial => 'guilds/guild', :as => :guild

if can? :manage, @raid
  json.permissions @raid.permissions, :partial => 'permissions/permission', :as => :permission
end
