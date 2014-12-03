class Ability
  include CanCan::Ability

  def initialize(account)
    # Everyone can manage raids that they have admin on
    can :manage, Raid do |raid|
      account.admin?(raid)
    end

    # Everyone can read raids that they have available
    can :read, Raid do |raid|
      account.available?(raid)
    end

    # Everyone can manage their own account
    can :manage, Account, :id => account.id

    # Everyone can create raids
    can :create, Raid
  end
end
