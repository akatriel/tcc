require 'httparty'
require 'nokogiri'
require 'json'



	#http response

	page = HTTParty.get 'http://www.verizonwireless.com', verify: false
	#Make Nokogiri object
	parse_page = Nokogiri::HTML(page)

#################### Phone Carousel ########################
	images = []
	makers = []
	models = []

	#parse phone carousel data
	@image_nodes = parse_page.css('#category1  .phone-carousel-slide-wrapper img')


	#grab srcs by traversing through nodes pushes them to array images
	@image_nodes.each{|node| images.push node.attributes['src'].to_s}

	#grabs maker and model
	@text_nodes = parse_page.css('#category1').css('.phone-carousel-slide-wrapper h5 a')
	@text_nodes.each do |node|
		makers << node.children.css('span').first.text
		models << node.children.css('span').last.text		
	end

	# @text_nodes.each{|node| node = node.text.split(' '); makers << node[0]; models << (node[1] << ' ' << node[2])}

	# @text_nodes.each_with_index.map{|node, index| index % 2 == 0 ? makers << node.text : models << node.text}

	# format textfile 1)img, 2)title, 3)subtitle
	package = []
	images.each_with_index do |image, index|
		package << image
		package << makers[index]
		package << models[index]
	end
	package.each{|pa| puts pa}

	# write phone_images.txt in root
	File.open("../../phone_images.txt", "w+") do |f|
		package.map{ |line| f.puts(line) }
	end


############# Deals Carousel ################



#############################################