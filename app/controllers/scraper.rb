require 'nokogiri'
require 'open-uri'

class Scraper
	attr_reader :theatres
	attr_accessor :location

	def initialize()
		@theatres = {}
		# @location = "Austin,+Tx" 
		@location = "78701"
	end
	

	def convert(name)
		return name.gsub(" ", "+")
	end

	def search_for_films(names)

		names.each do |film_name|
			puts("Search for Film : "+film_name[0]+" imdb : "+film_name[1]);
			name = convert(film_name[0])
			doc = Nokogiri::HTML(open("http://www.google.com/movies?hl=en&near=#{@location}&ei=JeSiUsuHDPOO2gWUy4CgCg&q=#{name}")) 
		
			#check for imdb match, prevents returning results for movies with similar names  
			doc.css(".movie meta[itemprop='sameas']").each do |match|
				if match["content"].include?(film_name[1])
					puts("Scraped meta content  is : "+match["content"])


					#theatre name loop
					doc.css(".showtimes .theater .name").each do |theatre_name|
						puts("Scraped theater Name is : "+theatre_name)
						if !@theatres[theatre_name.text]
							@theatres[theatre_name.text] = Theatre.new(theatre_name.text)
							if !@theatres[theatre_name.text].films[film_name[0]]
								@theatres[theatre_name.text].films[film_name[0]] = Film.new(film_name[0],film_name[1])
							end
						end
					end

					#addres loop
					doc.css(".showtimes .theater .address").each_with_index do |address,index|
						puts("Scraped address is : "+address);
						@theatres[doc.css(".showtimes .theater .name")[index].text].address = address.text
					end

					#times loop
					doc.css(".showtimes .theater .times").each_with_index do |times,index|	
					  puts("Scraped times is : "+times);			
						@theatres[doc.css(".showtimes .theater .name")[index].text].films[film_name[0]].times = times.text		 
					end
				end
  		end
		end
	end
end

class Theatre
	attr_accessor  :name, :address, :films
	def initialize(name ="")
		@name =name
		@address = ""
		@films ={}		
	end
end

class Film
	attr_accessor :title, :imdb, :times
	def initialize(name ="",imdb="")
		@title =name
		@imdb = imdb
	end
end