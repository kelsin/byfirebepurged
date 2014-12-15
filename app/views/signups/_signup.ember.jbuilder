json.extract! signup, :id, :note, :preferred
json.roles signup.role_ids
json.raid signup.raid_id
json.character signup.character_id

if @account.admin?(signup.raid) or !signup.raid.hidden or signup.raid.finalized
  json.role signup.role_id
  json.seated signup.seated
else
  json.role nil
  json.seated false
end
