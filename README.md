#ActorShowtimes
This is a web app designed with a straight forward concept in mind, you tell it an Actor's name and a zipcode, and it will respond with the current showtimes for any movie that Actor is in.  The initial version was created as a weekend Hackathon project for the MakerSquare program.  Following that weekend we have made continued improvements as we saw fit.  

===
###How to use it
There are two main use cases for this app.  The first use case assumes that a user has not set up an account.  In this case the user can enter in an Actors name and zipcode, aftr which the app will report back to the user the current movies and showtimes for that actor in the specified zipcode.  

The second use case, is only supported if a user has created an account.  This use case allows the user to use the same search feature from the first use case.  In addition, it allows a user to maintain a list of followed actors.  When a user signs in they can see the list of the actors they have followed and check each one for current showtimes.

===
###How it works
We used Ruby on Rails for the main front end site and Zurb Foundation for the styling.  For a user login process we use Devise gem.   There are two main process involved with this app.  The first process utilize 'themoviedb' gem.  This is a Ruby wrapper for the The Movie Database API.  The Movie Database, themoviedb.org, is a free and community maintained movie database.  We do an api call to search for the specified actor.  If we find a maching actor, we then do another call to get a list of their current movies.  The second process involves checking Google for showtimes for each movie based on the location provided by the user.  We use the nokogiri gem to process these showtimes.  As a final step we show a google map with the locations of the theatres where the movies are playing.  
 
