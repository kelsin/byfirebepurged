json.extract! raid, :id, :name, :date, :note, :finalized, :hidden
json.account raid.account_id
json.admin @account.admin?(raid)

json.groups do
  json.number raid.groups
  json.extract! raid, :size, :tanks, :healers
end

json.signups raid.signup_ids
json.permissions raid.permission_ids if can? :manage, raid
