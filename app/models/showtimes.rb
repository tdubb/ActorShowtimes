require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open("http://www.google.com/movies?hl=en&near=Austin,+TX&ei=JeSiUsuHDPOO2gWUy4CgCg&q=hunger+gams")) 
puts doc.class
@ad1 = doc.css(".address")[0].text
@ad2 = doc.css(".address")[1].text
@ad3 = doc.css(".address")[2].text
puts
puts doc.css(".name")[0].text
puts @ad1
puts doc.css(".times")[0].text
puts 
puts doc.css(".name")[1].text
puts @ad2
puts doc.css(".times")[1].text
puts 
puts doc.css(".name")[2].text
puts @ad3
puts doc.css(".times")[2].text
