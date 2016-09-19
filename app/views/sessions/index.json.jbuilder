json.api do
  json.login login_url
  json.account account_url
  json.raids raids_url
  json.raid raid_url(':id')
  json.signups raid_signups_url(':id')
  json.signup raid_signup_url(':id', ':id')
  json.permissions raid_permissions_url(':id')
  json.permission raid_permission_url(':id', ':id')
end

json.env Rails.env
json.revision app_revision

json.sites do
  json.website 'http://byfirebepurged.com/'
  json.docs 'http://docs.byfirebepurged.com/'
end
