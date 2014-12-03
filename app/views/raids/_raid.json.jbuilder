json.extract! raid, :id, :name, :date, :note, :finalized
json.account raid.account_id

json.status do
  json.creator @account.creator?(raid)
  json.admin @account.admin?(raid)
  json.signed_up @account.signed_up?(raid)
  json.seated @account.seated?(raid)
end

json.groups do
  json.number raid.groups
  json.extract! raid, :size, :tanks, :healers
end
