
require 'themoviedb'
require_relative './scraper'

class ActorsController < ApplicationController
  
  def new
  	@actor = Actor.new
  end

  def create
   # render  params.inspect 

    #error checking for empty name
    if params[:actor][:name].length ==0 
      flash[:notice] = "You may have forgotten to put an actor to search for?"
      @actor = Actor.new
      render 'app/views/actors/new.html.erb'
      return
    end 

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

    ####
    # Here we need to check to see if an actor is already is in the db
    # If so we need to grab that copy
    matches = Actor.where(:movie_db_id => "#{actor.movie_db_id}")
    if matches.length> 0
      actor = matches[0]
    end

    if user_signed_in? && params[:search] != "Search"
      #verify that these connection do not already exist before creating them
      if !current_user.actors.exists?(actor)
        current_user.actors << actor
      end
      if !actor.users.exists?(current_user)
        actor.users << current_user
      end
      actor.save
    end
  	
    @user = current_user

  	if !!params[:search]
      redirect_to actor_path("unsaved", {dbid: actor.movie_db_id, name: actor.name, pic: actor.picture_url, :zipcode => params[:zipcode]})
      #redirect_to actor_path(actor.id, {:zipcode => params[:zipcode]})
    else
      redirect_to index_path
    end
  end

  def index
    if !user_signed_in?
      redirect_to :controller=>'actors', :action => 'new'
    end
    @actor = Actor.new
    @user = current_user
    @actors = @user ? @user.actors.all : Actor.all
  end

  def show
    #render  params.inspect
    if !(params[:id]=="unsaved")
  	  @actor = Actor.find(params[:id])
    else
      @actor = Actor.new
    end
    if !!params[:name]
      @actor.name = params[:name]
    end
    if !!params[:dbid]
      @actor.movie_db_id = params[:dbid]
    end
    if !!params[:pic]
      @actor.picture_url = params[:pic]
    end
    # #given the actor, look up the movie they are in
    # actors_movies_ids = get_actors_movies_ids(@actor.movie_db_id)  
    
    # #check current movies for actor
    # actors_current_films = get_actors_playing_films(actors_movies_ids)

    #check all movies for actor
    actors_current_film_data = get_actors_films(@actor.movie_db_id)

    @flicks={}
    @zipcode = params[:zipcode]
    ip = request.remote_ip 
    obj = Geocoder.search(ip)
    if !@zipcode.present? || @zipcode.length < 5 
      @zipcode = obj[0].postal_code
    end
    if actors_current_film_data[0].length > 0 or actors_current_film_data[1].length > 0
      scrappy = Scraper.new
      scrappy.location = @zipcode
      #scrappy.search_for_films(actors_current_films)
      scrappy.scrape_all_movie_in_location()

      scrappy.theatres.delete_if do |name, theatre|
        films = theatre.films
        films.keep_if do |title, film|
          actors_current_film_data[0].include? title or actors_current_film_data[1].include? film.imdb 
        end
        films.empty?
      end

      @flicks = scrappy.theatres
    end
  end

   def destroy
      @actor = Actor.find(params[:id])
      if @actor.users.size <= 1 
        @actor.destroy
      else
        @actor.users.delete(current_user)
      end
        
      redirect_to index_path
    end

  private
  def actor_params
  	params.require(:actor).permit(:name)
  end

 #given actor store the movie they are in
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
    films.each do |movie|
      title = movie["title"]
      id = movie["id"]
      film = Tmdb::Movie.detail(id)
      imdb = film.imdb_id
      if actors_movies_ids.include? id
        actors_playing_films << [title,imdb]
      end
    end
    actors_playing_films
  end

  def get_actors_films(actor_moviedb_id)
    credits = Tmdb::People.credits(actor_moviedb_id)
    actors_movies = credits["cast"]
    actors_film_titles = []
    actors_films_imdb = []
    actors_movies.each do |movie|
      title = movie["title"]
      id = movie["id"]
      film = Tmdb::Movie.detail(id)
      imdb = film.imdb_id
      actors_film_titles << title #[title,imdb]
      if (imdb && imdb.length>0)
        actors_films_imdb << imdb
      end
    end
    [actors_film_titles,actors_films_imdb]
  end

end     