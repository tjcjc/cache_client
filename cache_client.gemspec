# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cache_client/version"

Gem::Specification.new do |s|
  s.name        = "cache_client"
  s.version     = CacheClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Tai"]
  s.email       = ["taijcjc@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{a plain cached objects client}
  s.description = %q{}

  s.rubyforge_project = "cache_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency(%q<redis>, [">=2.1.1"])
end
