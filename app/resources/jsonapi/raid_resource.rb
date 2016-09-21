class Jsonapi::RaidResource < JSONAPI::Resource
  attributes :name, :date, :note, :finalized,
             :groups, :size, :tanks,
             :healers, :requiredLevel, :requiredItemLevel,
             :created_at, :updated_at, :hidden

  def self.updatable_fields(context)
    super - [:created_at, :updated_at]
  end

  def self.creatable_fields(context)
    super - [:created_at, :updated_at]
  end

  def self.default_sort
    [{field: 'date', direction: :desc},
     {field: 'name', direction: :asc}]
  end

  has_one :account
  has_one :guild
  has_many :signups
  has_many :permissions
end
