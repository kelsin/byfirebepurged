json.raids @raids do |raid|
  json.partial! 'raids/raid', :raid => raid
end

json.accounts @all_accounts, :partial => 'accounts/account', :as => :account
json.signups @all_signups, :partial => 'signups/signup', :as => :signup
json.characters @all_characters, :partial => 'characters/character', :as => :character
json.guilds @all_guilds, :partial => 'guilds/guild', :as => :guild
json.roles roles, :partial => 'roles/role', :as => :role
