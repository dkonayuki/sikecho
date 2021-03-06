class Ability
  #define whether user can access to pages or not
  include CanCan::Ability

  def initialize(user, request=nil)
    can :read, Subject                # allow everyone to view Subject :index and :show, and can read other pages if authorize is not called
    can :read, University             # allow first time user to see list of university, and university info page
    # faculty and course index pages will not be able to viewed for better ui
    
    if user
      
      if user.role == 'admin'
        can :access, :rails_admin     # only allow admin users to access Rails Admin
        can :dashboard                # allow access to dashboard: /admin
        can :manage, :all
      elsif user.role == 'mod'
        can :manage, :all             # this will include :read, :show, :edit, :update, and :delete
      else
        #normal user
        can :show, User                                 # see other users
        
        #teacher index can be viewed by render template or partial without trigger the ability
        #can :read, Teacher                              
        
        can :manage, Education do |e|                   # owner can manage his educations
          e.user == user
        end
        can :read, Education do |e|                     # can view other users' educations if they are public
          e.user.settings(:education).public == 1
        end
      end
      
      # if subdomain is from user's university
      # add many new abilities for user
      if request != nil && University.find_by_codename(request.subdomain) == user.current_university
        can [:show, :create, :update], Teacher
        
        can [:create, :update], Subject                 # allow user to update his university's subjects only
        
        can :update, User do |u|                        # only user can edit his profile
          u == user
        end
        
        can [:read, :create], Note                      # create note only in user's university
        can [:update, :destroy], Note do |t|            # owner can edit
          t.user == user
        end
        
        can [:create], Comment
        can [:update, :destroy], Comment do |t|         # owner can edit
          t.user == user
        end
        
        can [:create, :show], Document
        can [:update, :destroy], Document do |d|        # owner can edit
          d.note.user == user
        end
        
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
