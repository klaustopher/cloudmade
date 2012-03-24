# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudmade/version"

Gem::Specification.new do |s|
  s.name        = "cloudmade"
  s.version     = Cloudmade::VERSION
  s.authors     = ["Klaus Zanders", "cloudmade.com"]
  s.email       = ["klaus.zanders@gmail.com", "ishubovych@cloudmade.com"]
  s.homepage    = "http://developers.cloudmade.com/projects/show/ruby-lib"
  s.summary     = 'CloudMade Ruby API'
  s.description = s.summary

  s.rubyforge_project = "cloudmade"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.has_rdoc    = true
  s.extra_rdoc_files = ['README', 'LICENSE']

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end