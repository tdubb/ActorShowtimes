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
			name = convert(film_name)
			doc = Nokogiri::HTML(open("http://www.google.com/movies?hl=en&near=#{@location}&ei=JeSiUsuHDPOO2gWUy4CgCg&q=#{name}")) 
		
			#theatre name loop
			doc.css(".name").each do |theatre_name|
				if !@theatres[theatre_name.text]
					@theatres[theatre_name.text] = Theatre.new(theatre_name.text)
					if !@theatres[theatre_name.text].films[film_name]
						@theatres[theatre_name.text].films[film_name] = Film.new(film_name)
					end
				end
			end

			#addres loop
			doc.css(".address").each_with_index do |address,index|
				@theatres[doc.css(".name")[index].text].address = address.text
			end

			#times loop
			doc.css(".times").each_with_index do |times,index|				
				@theatres[doc.css(".name")[index].text].films[film_name].times = times.text		 
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
	attr_accessor :title, :times
	def initialize(name ="")
		@title =name
	end
end