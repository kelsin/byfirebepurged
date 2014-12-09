json.permissions @permissions do |permission|
  json.partial! 'permissions/permission', :permission => permission
end
