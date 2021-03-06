$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fiddler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fiddler"
  s.version     = Fiddler::VERSION
  s.authors     = ["Jais Cheema"]
  s.email       = ["jais.cheema@cybersecure.com.au"]
  s.homepage    = "https://github.com/jaischeema/fiddler"
  s.summary     = "Interface to Request Tracker based on Roart Gem"
  s.description = "This is the interface to request tracker based on Roart Gem"

  s.files = Dir["{lib,spec}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'httpclient', '2.2.7'
  s.add_dependency 'activesupport'
  s.add_dependency 'awesome_print'
  s.add_dependency 'active_attr'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'watchr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
end
