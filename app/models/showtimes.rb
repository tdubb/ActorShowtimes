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


<ol>
	 <li>
	 	<% @theaters.each do |theater| %>
		<%= theater.name %>
		<br>
		<=% theater.address %>
		<br>
			<% theater.films.each do |film| %>
				<%= film.title %>
				<br>
				<% film.times.each do |time| %>
					<%= time %>
				<% end %>
			<% end %>
		<% end %>
	</li>
 </ol>

 <!-- <!-- <!-- <!-- 
 <img src="<%= @actor.picture_url %>">
 <br>
 <% @film_names = ['Thor', 'Frozen'] %>
 <% @film_names.each do |film_name| %>

 <% doc = Nokogiri::HTML(open("http://www.google.com/movies?hl=en&near=Austin,+TX&ei=JeSiUsuHDPOO2gWUy4CgCg&q=#{film_name}")) %>

<%=  doc.css(".address").length > 0 ? @ad1 = doc.css(".address")[0].text : nil  %>

<ol>
	<li style="text-align:center; list-style-position:inside">
		<%= doc.css(".name").length > 0 ? doc.css(".name")[0].text : nil %>
		<br>
		<%= @ad1 %>
		<br>
		<%= doc.css(".times").length > 0 ? doc.css(".times")[0].text : nil %>
		</p>
	</li> --> --> --> -->
<!-- 	<li style="text-aling:center; list-style-position:inside">
		# <= doc.css(".name")[1].text %>
		<br>
		<%= @ad2 %>
		<br>
		<= doc.css(".times")[1].text %>
		</p>
	</li>
	<li style="text-aling:center; list-style-position:inside">
		<= doc.css(".name")[2].text %>
		<br>
		<%= @ad3 %>
		<br>
		<= doc.css(".times")[2].text %>
		</p>
	</li> -->
</ol>

<% end %>

</body>







<!-- <img id="event_map" src="http://maps.googleapis.com/maps/api/staticmap?center=AustinTX&zoom=13&sensor=false&size=600x300&key=AIzaSyAsl-bySeZhlYKZkQL1UI_DIeHQVgoZCFo">
 -->

