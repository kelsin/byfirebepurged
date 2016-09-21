class Jsonapi::RoleResource < JSONAPI::Resource
  attributes :name, :slug, :icon, :class_ids

  immutable
end
