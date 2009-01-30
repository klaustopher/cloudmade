require 'cloudmade'

puts "Points\n------"
puts CloudMade::Point.new(1.1, 2.2)
puts CloudMade::Point.new([1.3, 2.4])

puts "\nLines\n-----"
puts CloudMade::Line.new([[1.1, 2.0], [0.1, 2.0]])

puts "\nPolygons\n-------"
puts CloudMade::Polygon.new([[[1.0, 2.0], [0.0, 2.0], [3.0, 4.0]], [[1.5, 2.5], [0.5, 2.5], [2.5, 4.5]]])

#a = [1, 2, 3, 4, 5]
#puts a.slice(1, a.length)