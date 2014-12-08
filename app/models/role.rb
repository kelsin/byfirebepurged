class Role < ActiveRecord::Base
  has_many :class_roles
  has_and_belongs_to_many :signups

  def class_ids
    class_roles.map(&:class_id)
  end
end
