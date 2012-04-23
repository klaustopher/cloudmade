# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudmade/version"

Gem::Specification.new do |s|
  s.name        = "cloudmade"
  s.version     = Cloudmade::VERSION
  s.authors     = ["Klaus Zanders", "forked from cloudmade.com"]
  s.email       = ["klaus.zanders@gmail.com", "ishubovych@cloudmade.com"]
  s.homepage    = "https://github.com/klaustopher/cloudmade"
  s.summary     = 'CloudMade Ruby API'
  s.description = s.summary

  s.rubyforge_project = "cloudmade"

  s.files         = `git ls-files`.split("\n")
  s.test_files    =  Dir.glob('test/test_*.rb')
  s.require_paths = ["lib"]
  
  s.has_rdoc    = true
  s.extra_rdoc_files = ['README.md', 'LICENSE']

  # specify any dependencies here; for example:
  s.add_development_dependency "test-unit"
  s.add_development_dependency "rake"
  # s.add_runtime_dependency "rest-client"
end