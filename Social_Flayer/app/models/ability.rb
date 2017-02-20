class Ability
  include CanCan::Ability

  def initialize(user)


    user ||= User.new # guest user (not logged in)
    alias_action :back, :change, to: :roles
    alias_action :edit, :update, :destroy, :addadmin, :change_admin, to: :owner_ab
    alias_action :show, :create, :edit, :update, :destroy, to: :crud_prod
    alias_action :new,:create,:edit,:update,:destroy, to: :crud_respond

    if user.admin?
      can :manage,:all
    end

    if user.roles_mask==0
      #user
      can :follow, User do |client|
        !FollowerUser.where(follower_id: user.id,followed_id:client.id).exists? && client.id != user.id
      end

      can :unfollow, User do |client|
        FollowerUser.where(follower_id: user.id,followed_id:client.id).exists? && client.id != user.id
      end

      #can menage  it self
      can :manage, User do |client|
       client.id == user.id
      end

      can :show, User
      can :index, User
      alias_action :new, :create, :show, :upvote, :index,:downvote,:choose_no,:choose_yes, to: :funzioniruolo0
      #store

      can :funzioniruolo0, Store


      #control if an user can follow a store or he has already followed it.
      can :follow, Store do |store|
         !FollowStore.where(store_id: store.id, user_id: user.id).exists?
      end
      #control if an user wants to unfollow, he has to be a foolower
      can :unfollow, Store do |store|
         FollowStore.where(store_id: store.id, user_id: user.id).exists?
      end

      #product
      can :show, Product


      #comment
      can :new,Comment do |comment|
        !Work.where(store_id: comment.store_id, user_id: user.id).exists?
      end
      can :reply,Comment do |comment|
        !Work.where(store_id: comment.store_id, user_id: user.id).exists?
      end
      can :create , Comment do |comment|
         !Work.where(store_id: comment.store_id, user_id: user.id).exists?
      end
      alias_action :update, :edit, :destroy,  to: :funzionistessouserid
      can :funzionistessouserid, Comment do |comment|
        comment.user_id==user.id
      end

      can :indexReply,Comment

    elsif user.roles_mask==1
      #user
      can :roles, User

      #store
      can :show, Store do |store|
        Work.where(store_id: store.id, user_id: user.id).exists?
      end

      can :owner_ab, Store do |store|
        store.owner_id==user.id
      end

      #product
      can :crud_prod, Product do |product|
        Work.where(store_id: product.store_id, user_id: user.id).exists?
      end

      can :new, Product


      #respond


      can :crud_respond ,Respond do |risp|
        Store.where(id: risp.store_id,owner_id: user.id).exists?
      end


    elsif user.roles_mask==2
      #user
      can :back, User
      can :change, User

      #store
      can :show, Store do |store|
        Work.where(store_id: store.id, user_id: user.id).exists?
      end

      can :leave_store, Store do |store|
        Work.where(store_id: store.id, user_id: user.id).exists?
      end


      #product
      can :show, Product do |product|
        Work.where(store_id: product.store_id, user_id: user.id).exists?
      end

      can :new, Product

      can :create, Product do |product|
        Work.where(store_id: product.store_id, user_id: user.id).exists?
      end

      can :edit, Product do |product|
        Work.where(store_id: product.store_id, user_id: user.id).exists?
      end

      can :update, Product do |product|
        Work.where(store_id: product.store_id, user_id: user.id).exists?
      end

      can :destroy, Product do |product|
        Work.where(store_id: product.store_id, user_id: user.id).exists?
      end

      #respond
      can :new,Respond do |risp|
        Work.where(store_id: risp.store_id,user_id: user.id,accept: true).exists?
      end
      can :create,Respond do |risp|
        Work.where(store_id: risp.store_id,user_id: user.id,accept: true).exists?
      end
      can :edit,Respond do |risp|
        Work.where(store_id: risp.store_id,user_id: user.id,accept: true).exists?
      end
      can :update,Respond do |risp|
        Work.where(store_id: risp.store_id,user_id: user.id,accept: true).exists?
      end
      can :destroy,Respond do |risp|
        Work.where(store_id: risp.store_id,user_id: user.id,accept: true).exists?
      end

    else
      can :read, :all
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
