json.signups @raid.signups, :partial => 'signups/signup', :as => :signup
json.characters @raid.characters, :partial => 'characters/character', :as => :character
json.guilds @raid.guilds, :partial => 'guilds/guild', :as => :guild
json.roles roles, :partial => 'roles/role', :as => :role
