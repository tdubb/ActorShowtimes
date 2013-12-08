require 'themoviedb'
require_relative './scraper'

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
      flash[:notice] = "Oh no...we've never heard of them, are you sure you spelled that right?"
      @actor = Actor.new
      render 'app/views/actors/new.html.erb'
      return
    end

    # select the desired entry.  Here we would want to allow the user to pick
    # from the returned results which is the actor they meant.  For now we will 
    # be using the first resturned result 
    first_actor = actors[0]

    #error checking
    if first_actor.nil? 
      flash[:notice] = "Oh no....we've never heard of them, are you sure you spelled that right?"
      @actor = Actor.new
      render 'app/views/actors/new.html.erb'
      return
    end

    #save the id
    actor.movie_db_id = first_actor.id

    # bring up the images associated withthis actor
    format_array = Tmdb::People.images(first_actor.id)["profiles"]

    # choose last image  from the set
    pic_hash =  format_array.last

    #configuration is needed to get the base_url where the images can be accessed
    configuration = Tmdb::Configuration.new
    if !pic_hash.nil?
        # form the URL, configuration.profile_sizes => w45,w185, h632, original
        actor.picture_url = "#{configuration.base_url}#{configuration.profile_sizes[1]}#{pic_hash["file_path"]}"  
    end



    #save the actor with the picture_url to the database
    current_user.actors << actor
  	actor.save
    @actors = Actor.all
  	render 'app/views/actors/index.html.erb'
  end

  # def index
  # 	@actors = Actor.all
  # end
  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @actors = @user ? @user.actors.all : Actor.all
  end


  def show
  	@actor = Actor.find(params[:id])
    #given actor store the movie they are inovies
    actors_movies_ids = get_actors_movies_ids(@actor.movie_db_id)  
    
    #check current movies for actor
    actors_current_films = get_actors_playing_films(actors_movies_ids)
    
    @flicks={}
 
    if actors_current_films.length > 0
      scrappy = Scraper.new
      scrappy.search_for_films(actors_current_films)
      @flicks = scrappy.theatres
    end
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

 #given actor store the movie they are inovies
  def get_actors_movies_ids(actor_moviedb_id)  
    credits = Tmdb::People.credits(actor_moviedb_id)
    actors_movies = credits["cast"]
    actors_movies_ids = []
    actors_movies.each do |movie|
      actors_movies_ids << movie["id"]
    end
    actors_movies_ids
  end
    
  def get_actors_playing_films(actors_movies_ids)
    films = Tmdb::Movie.now_playing
    actors_playing_films = []
    films.each do |x|
      title = x["title"]
      if actors_movies_ids.include? x["id"]
        actors_playing_films << title
      end
    end
    actors_playing_films
  end

end     