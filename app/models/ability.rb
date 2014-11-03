class Ability
  include CanCan::Ability

  def initialize(user, request=nil)
    can :read, :all                   # allow everyone to read everything
    if user
      can :update, Subject do |subject| # allow user to update his university's subjects only
        University.find_by_codename(request.subdomain) == user.current_university
      end
      
      can :update, User do |u|       # only user can edit his profile
        u == user
      end
      
      can [:update, :destroy], [Note, Comment] do |t| # owner can edit
        t.user == user
      end
      
      if user.role == 'admin'
        can :access, :rails_admin     # only allow admin users to access Rails Admin
        can :dashboard                # allow access to dashboard
        can :manage, :all
      elsif user.role == 'mod'
        can :manage, :all             # allow mod to manage
      end
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
