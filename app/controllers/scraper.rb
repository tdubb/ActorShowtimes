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

	def scrape_all_movie_in_location()	
		links = ["/movies?near=#{@location}&hl=en&view=list"]
		#scrape first page for other page links      
	  doc = Nokogiri::HTML(open("http://www.google.com"+links[0]))
		doc.css("#navbar a").each do |a|
			link = a["href"]
			puts("Scraped url is : "+link)	  
			links << link 
		end

		#last element is typically a duplicate represented by 'Next' on the page
		if links.length > 1
			links.pop
		end

		links.each do |page|
			scrape_page_for_showtimes(page)
		end

		# This is the structure of the navigation for more results
    # <div id="navbar" class="n">
    #     <table border="0" cellpadding="0" width="1%" cellspacing="0" align="center">
    #         <tbody>
    #             <tr align="center" style="text-align:center" valign="top">
    #                 <td nowrap="">
    #                     <img src="//www.google.com/nav_first.gif" width="18" height="26" alt="">
    #                     <br>
    #                 </td>
    #                 <td nowrap="">
    #                     <img src="//www.google.com/nav_current.gif" width="16" height="26" alt="">
    #                     <br>
    #                     <span class="i">1</span>
    #                 </td>
    #                 <td nowrap="">
    #                     <a href="/movies?near=78757&amp;hl=en&amp;view=list&amp;start=10"><img src="//www.google.com/nav_page.gif" width="16" height="26" alt="" border="0"><br>2</a>
    #                 </td>
    #                 <td nowrap="" class="b">
    #                     <a href="/movies?near=78757&amp;hl=en&amp;view=list&amp;start=10"><img src="//www.google.com/nav_next.gif" width="100" height="26" alt="" border="0"><br>Next</a>
    #                 </td>
    #             </tr>
    #         </tbody>
    #     </table>
    # </div>
	end

	def scrape_page_for_showtimes(link)
		doc = Nokogiri::HTML(open("http://www.google.com"+link)) 

		doc.css(".movie_results .theater .desc").each do |desc|

			theatre_name = desc.children[0] #doc.css(".movie_results .theater ##{desc_id} .name").first
			puts("Scraped theater Name is : "+theatre_name)						
			if !@theatres[theatre_name.text]
				@theatres[theatre_name.text] = Theatre.new(theatre_name.text)
			end

			address = theatre_name.next #doc.css(".movie_results .theater ##{desc_id} .info").first
			#strip off phone number
			val = address.text.split(' - (', 2)
			if (val)
				address = val[0]
			else
				address =address.text	
			end
			puts("Scraped theater address is : "+address)
			@theatres[theatre_name.text].address = address

			showtimes = desc.next()
			showtimes.css(".movie").each do |movie|
				title = movie.children[0]
				puts("Scraped movie title is : "+title.text)
				if !@theatres[theatre_name.text].films[title]
					@theatres[theatre_name.text].films[title.text] = Film.new(title.text)
				end

				times = movie.children[2]
				puts("Scraped movie times is : "+times.text)
				@theatres[theatre_name.text].films[title.text].times = times.text		 
			end	# of showtimes.css(".movie").each do |movie|
		end # of doc.css(".movie_results .theater .desc").each do |desc|

		# This is the structure for theatre/movies/showtimes
	  # <div id="movie_results">
	  #     <div class="movie_results">
	  #         <div class="theater">
	  #             <div class="desc" id="theater_13726688112417423092">
	  #                 <h2 class="name">
	  #                     <a href="/movies?near=78757&amp;hl=en&amp;view=list&amp;tid=be7efe1c7337bef4"
	  #                     id="link_1_theater_13726688112417423092">Alamo Drafthouse Cinema - Village</a>
	  #                 </h2>
	  #                 <div class="info">2700 West Anderson Lane, Austin, TX - (512) 476-1320 ext. 3805
	  #                     <a href=""
	  #                     class="fl" target="_top"></a>
	  #                 </div>
	  #             </div>
	  #             <div class="showtimes">
	  #                 <div class="show_left">
	  #                     <div class="movie">
	  #                         <div class="name">
	  #                             <a href="/movies?near=78757&amp;hl=en&amp;view=list&amp;mid=3f0f1089e508e65c">Anchorman 2: The Legend Continues</a>
	  #                         </div>
	  #                         <span class="info">‎1hr 59min‎‎ - Rated PG-13‎‎ - Comedy‎ -
	  #                             <a href="/url?q=http://www.youtube.com/watch%3Fv%3DZyOW0I--Xm8&amp;sa=X&amp;oi=movies&amp;ii=0&amp;usg=AFQjCNEk0F1K8eMmhE6R9br1FKu62pdgRg"
	  #                             class="fl">Trailer</a>-
	  #                             <a href="/url?q=http://www.imdb.com/title/tt1229340/&amp;sa=X&amp;oi=moviesi&amp;ii=0&amp;usg=AFQjCNGsRlVjc-z7FjVurtaFRCEn8gdKjg"
	  #                             class="fl">IMDb</a>
	  #                         </span>
	  #                         <div class="times">
	  #                             <span style="color:#666">
	  #                                 <span style="padding:0 ">&nbsp;‎</span>
	  #                                 <!-- -->7:30‎</span>
	  #                             <span style="color:">
	  #                                 <span style="padding:0 ">&nbsp;‎</span>
	  #                                 <!-- -->
	  #                                 <a href="/url?q=http://www.fandango.com/redirect.aspx%3Ftid%3DAAPPY%26tmid%3D129641%26date%3D2014-01-03%2B22:55%26a%3D11584%26source%3Dgoogle&amp;sa=X&amp;oi=moviesf&amp;ii=0&amp;usg=AFQjCNHjqg9R_EFWswvB-fYI9ywr2hqHXQ"
	  #                                 class="fl">10:55pm‎</a>
	  #                             </span>
	  #                         </div>
	  #                     </div>
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