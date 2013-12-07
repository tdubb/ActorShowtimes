require 'themoviedb'

class ActorsController < ApplicationController
  
  def new
  	@actor = Actor.new
  end

  def create
  	actor = Actor.new(actor_params)

    Tmdb::Api.key(ENV['THEMOVIEDB_API_KEY'])

    #search the moviedb for matching entries
    actors = Tmdb::People.find(actor.name)

    #error checking
    if actors.length ==0 
      @msg = "Unfortunately we do not have an actor with this name in our system"
      redirect_to root_path
      return
    end

    # select the desired entry.  Here we would want to allow the user to pick
    # from the returned results which is the actor they meant.  For now we will 
    # be using the first resturned result 
    first_actor = actors[0]

    #error checking
    if first_actor.nil? 
      @msg = "Unfortunately we do not have an actor with this name in our system"
      redirect_to root_path
      return
    end

    # bring up the images associated withthis actor
    format_array = Tmdb::People.images(first_actor.id)["profiles"]

    # choose last image  from the set
    pic_hash =  format_array.last

    #configuration is needed to get the base_url where the images can be accessed
    configuration = Tmdb::Configuration.new

    # form the URL, configuration.profile_sizes => w45,w185, h632, original
    actor.picture_url = "#{configuration.base_url}#{configuration.profile_sizes[1]}#{pic_hash["file_path"]}"  

    #save the actor with the picture_url to the database
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

       