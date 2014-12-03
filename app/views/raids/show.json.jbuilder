json.raid do
  json.partial! 'raids/raid', :raid => @raid
  json.permissions @raid.permission_ids
end

json.permissions @raid.permissions, :partial => 'permissions/permission', :as => :permission
