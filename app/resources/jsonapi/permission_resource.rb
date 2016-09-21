class Jsonapi::PermissionResource < JSONAPI::Resource
  attributes :key, :level, :permissioned_id, :permissioned_type
end
