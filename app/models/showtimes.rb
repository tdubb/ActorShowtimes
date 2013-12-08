require 'nokogiri'
require 'open-uri'

# doc = Nokogiri::HTML(open("http://www.google.com/movies?hl=en&near=Austin,+TX&ei=JeSiUsuHDPOO2gWUy4CgCg&q=hunger+games")) 
# puts doc.class
# @ad1 = doc.css(".address")[0].text
# @ad2 = doc.css(".address")[1].text
# @ad3 = doc.css(".address")[2].text
# puts
# puts doc.css(".name")[0].text
# puts @ad1
# puts doc.css(".times")[0].text
# puts 
# puts doc.css(".name")[1].text
# puts @ad2
# puts doc.css(".times")[1].text
# puts 
# puts doc.css(".name")[2].text
# puts @ad3
# puts doc.css(".times")[2].text
class Scraper
	attr_reader :theares

	def initialize()
		@theares = {}
	end
	
	def get_loocation
		return "Austin,+Tx"
	end

	def convert(name)
		return name.gsub(" ", "+")
	end

	def search_for_films(names)

		location = get_location
		names.each do |film_name|
			name = convert(film_name)
			doc = Nokogiri::HTML(open("http://www.google.com/movies?hl=en&near=#{get_location}&ei=JeSiUsuHDPOO2gWUy4CgCg&q=#{name}")) 
			
			#theatre name loop
			doc.css(".name").each do |theatre_name|
				if !@theares[theatre_name.text]
					@theares[theatre_name] = Theatre.new(theatre_name.text)
					if !@theares[theatre_name.text].films[film_name]
						@theares[theatre_name.text].films[film_name] = Film.new(film_name)
				end
			end

			#addres loop
			doc.css(".address").each_with_index do |address,index|
				@theares[doc.css(".name")[index]].address = address.text
			end

			#times loop
			doc.css(".times").each_with_index do |times,index|
				@theares[theatre_name.text].films[film_name].times = times.text		 
			end
		end
  end
end

class Theatre
	@name
	@address
	@films   #hash film_name, film obj
	def initialize(name ="")
		@name =name
	end
end

class Film
	attre_reader :title, :times
	def initialize(name ="")
		@title =name
	end
end