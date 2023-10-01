class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :manage, :all
    elsif user.is_a?(Owner)
      can [:create, :read, :update, :destroy], Owner
    elsif user.is_a?(Employee)
      can [:create, :read, :update], Employee
    elsif user.is_a?(Employer)
      can [:create, :read, :update], Employer
    elsif user.is_a?(Applicant)
      can [:create, :read, :update], Applicant
    end
  end
end