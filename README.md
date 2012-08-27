# CloudMade
[![Build Status](https://secure.travis-ci.org/klaustopher/cloudmade.png?branch=master)](http://travis-ci.org/klaustopher/cloudmade)
---

This is a ruby Gem to use the amazing API for [Cloudmade](http://www.cloudmade.com). They bring you cool services powered by [OpenStreetMaps](http://www.openstreetmaps.org). Check out their website.

In their developer section I found this ruby gem which wasn't on [rubygems.org](http://www.rubygems.org). So I forked their project from SVN, updated the Gemspec (Nothing has happened with this Gem for over 2 years) and published it here.

In the future I will update this Gem to use the version v2 of the API. I just :heart: the service and I'd love to see it being used by more people.


## Usage
Add the Gem to your Gemfile:
  gem 'cloudmade', '0.1.4'

Run the bundle command to update your Gemspec and you're ready to roll

Go to http://cloudmade.com/start sign up and request an API key

## Examples
````ruby
  cm = CloudMade::Client.from_parameters('YOUR-API-KEY')
  
  # Find a place
  places = cm.geocoding.find('Potsdamer Platz, Berlin, Germany')
  puts "Location of Potsdamer Platz: #{places.results[0].centroid.lat}, #{places.results[0].centroid.lon}"
  
  # Find a pub
  pub = cm.geocoding.find_closest('pub', 52.50938, 13.37627)
  puts "Closest Pub: #{pub.properties.name}"
```

Some other examples can be found in `lib/cloudmade/examples.rb` (*I didn't put that file there, it has been provided*)

## License
This version is licensed under the LGPL version 3, see `LICENSE` for details (This has also been provided by CloudMade. My new version of the Gem will be MIT)

# Original documentation
At the end I will attach the original documentation. Have fun:
---

CloudMadeAPI is a Ruby API for CloudMade's online services: Geocoding, Routing and Tiles.

API documentation is available http://cloudmade.com/developers/docs/

Install
=======

Using easy_install

	gem install cloudmade

Testing
=======

To test the source distribution you will need to run following command:

    rake test

Module Documentation
====================

To generate module documentation you will need to run the following command:

    rake rdoc