class StoresController < ApplicationController
before_action :store, only: [:show, :edit, :update,:destroy,:upvote,:downvote]

  def show
    @show=@store
  end

  def new
    @store=Store.new
  end

  def create
    @store=Store.new(store_params)
    puts current_user.id
    @store.owner_id=current_user.id

    if @store.save
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @store.update(store_params)
      redirect_to store_path(@store)
    else
      render 'edit'
    end
  end

  def destroy
    @store.destroy
    current_user.update(roles_mask: 0)
    redirect_to root_path
  end

  def index
    @stores=Store.all
  end
  def upvote
    @store.upvote_from current_user
    redirect_to store_path(@store)
  end

  def downvote
    @store.downvote_from current_user
    redirect_to store_path(@store)
  end
  protected
  #funzione che seatta un parametro
  def store
    @store=Store.find(params[:id])
  end
  #
  def store_params
    params.require(:store).permit(:name,:location)
  end
end
