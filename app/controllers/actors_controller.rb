require 'themoviedb'

class ActorsController < ApplicationController
  
  def new
  	@actor = Actor.new
  end

  def create
  	actor = Actor.new(actor_params)
    Tmdb::Api.key(ENV['THEMOVIEDB_API_KEY'])
    actors = Tmdb::People.find(actor.name)
    first_actor = actors[0]
    format_array = Tmdb::People.images(first_actor.id)["profiles"]
    pic_hash =  format_array.last
    configuration = Tmdb::Configuration.new
    # configuration.profile_sizes => w45,w185, h632, original
    actor.picture_url = "#{configuration.base_url}#{configuration.profile_sizes[1]}#{pic_hash["file_path"]}"  

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

       