require 'cloudmade'
include CloudMade

cm = CloudMade::Client.from_parameters('BC9A493B41014CAABB98F0471D759707')

puts 'Testing CloudMade Client'
puts "Geocoding"
puts "---------"
puts "Find"
puts cm.geocoding.find('Potsdamer Platz, Berlin, Germany')
puts "Find closest"
puts cm.geocoding.find_closest('pub', 51.66117, 13.37654)

puts "Routing\n-------\n"
puts cm.routing.route(
  CloudMade::Point.new(47.25976, 9.58423),
  CloudMade::Point.new(47.66117, 9.99882))

puts "Tiles\n-----\n"
tile = cm.tiles.get_tile(50.39947, 30.6479, 15)
file = File.new('my_tile.png', 'w')
file.write(tile)
file.close