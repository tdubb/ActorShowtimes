class ActorsController < ApplicationController
  
  def new
  	@actor = Actor.new
  end

  def create
  	actor = Actor.new(actor_params)
  	actor.save
  	redirect_to actor_index_path
  end

  def index
  	@actors = Actor.all

  end

  def show
  	@actor = Actor.find(params[:id])
  end

  private
  def actor_params
  	params.require(:actor).permit(:name)
  end

end

				