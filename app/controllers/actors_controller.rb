class ActorsController < ApplicationController
  
  def new
  	@actor = Actor.new
  end

  def create
  	actor = Actor.new(actor_params)
  	actor.save
  	redirect_to index_path
  end

  def index
  	@actors = Actor.all

  end

  def show
  	@actor = Actor.find(params[:id])
  end

   def destroy
      @actor = Actor.find(params[:id])
      @actor.destroy
      redirect_to index_path
    end

  private
  def actor_params
  	params.require(:actor).permit(:name)
  end

end

       