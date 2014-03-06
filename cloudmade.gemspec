# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudmade/version"

Gem::Specification.new do |s|
  s.name        = "cloudmade"
  s.version     = Cloudmade::VERSION
  s.authors     = ["Klaus Zanders", "forked from cloudmade.com"]
  s.email       = ["klaus.zanders@gmail.com", "ishubovych@cloudmade.com"]
  s.homepage    = "https://github.com/klaustopher/cloudmade"
  s.summary     = 'DEPRECATED. Please use https://github.com/CloudMade/Tools'
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

  s.post_install_message = <<-MESSAGE
=======================================
= CloudMade Gem                       =
=======================================
= A lot has happened with CloudMade   =
= since I forked this Gem. Since then =
= They have released a new version    =
= of the gem themselves and I am no   =
= longer maintaining this one. So I   =
= suggest you switch to their new im- =
= plementation                        =
=                                     =
= https://github.com/CloudMade/Tools  =
=======================================
MESSAGE
end
