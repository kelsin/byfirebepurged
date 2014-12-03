class Permission < ActiveRecord::Base
  belongs_to :permissioned, :polymorphic => true

  validates :level, :presence => true, :inclusion => { :in => %w(admin member) }
  validates :key, :presence => true

  def self.admin
    where(:level => 'admin')
  end

  def type
    @type ||= key.split('|').first
  end

  def args
    @args ||= key.split('|').second
  end

  def vars
    @vars ||= args.split(':')
  end

  def admin?
    level == 'admin'
  end

  def member?
    level == 'member'
  end
end
