class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

		return unless user
    if user.has_role?('admin')
      can :manage, :all
    else
      can :manage, User, :id => user.id
      #can :manage, Project, :id => user.clients.map{|client| client.projects}.flatten.map(&:id)
      can :manage, Project, :id => user.projects.where("memberships.status >= ?", 3).map(&:id)
      can :read, Project, :id => user.projects.where("memberships.status >= ?", 1).map(&:id)
      can :create, Project
      can [:accept_invitation, :reject_invitation], Project, :id => user.projects.where("memberships.status >= ?", 0).map(&:id)

			can :manage, Client, :id => user.clients.map(&:id)
			can :create, Client
			can :read, Client, :id => user.employment.employer.clients.map(&:id)
			
			can :manage, Contact, :id => user.clients.map{|client| client.contacts}.flatten.map(&:id)

      can :manage, Employment, :employer_id => user.id
      can :read, Employment, :employee_id => user.id
    end
  end
end
