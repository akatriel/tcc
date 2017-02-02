require 'httparty'
require 'nokogiri'
require 'json'
require 'byebug'
#http response
page = HTTParty.get 'http://www.verizonwireless.com'
#Make Nokogiri object
parse_page = Nokogiri::HTML(page)

images = []
makers = []
models = []

#parse phone carousel data
image_nodes = parse_page.css('li.phone-carousel-slide').css('img')
#grab srcs by traversing through nodes pushes them to array images
image_nodes.each{|node| images.push node.attributes['data-src'].to_s unless node.attributes['data-src'].to_s == ""}

#grabs maker and model
text_nodes = parse_page.css('.phone-carousel').css('.phone-carousel-slide-wrapper').children.children.css('a > span')
text_nodes.each_with_index.map{|node, index| index % 2 == 0 ? makers << node.text : models << node.text}

## format textfile 1)img, 2)title, 3)subtitle
package = []
images.each_with_index do |image, index|
	package << image
	package << makers[index]
	package << models[index]
end

File.open("phone_images.txt", "w+") do |f|
	package.map{ |line| f.puts(line) }
end
