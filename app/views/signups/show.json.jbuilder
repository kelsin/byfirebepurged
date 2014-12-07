json.signup do
  json.partial! 'signups/signup', :signup => @signup
end
json.characters [@signup.character], :partial => 'characters/character', :as => :character
json.guilds [@signup.character.guild], :partial => 'guilds/guild', :as => :guild if @signup.character.guild
json.roles roles, :partial => 'roles/role', :as => :role
