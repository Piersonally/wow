$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wow/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wow"
  s.version     = Wow::VERSION
  s.authors     = ["Sam Pierson"]
  s.email       = ["gems@sampierson.com"]
  s.homepage    = ""
  s.summary     = "WoW Auction Data Mining Plugin"
  s.description = "WoW Auction Data Mining Plugin"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.0"
  s.add_dependency "haml-rails"
  s.add_dependency "meta-tags"
  s.add_dependency "simple_form", "3.1.0.rc1"
  s.add_dependency "foreigner"
  s.add_dependency "sidekiq"
  s.add_dependency "sidetiq"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", ">= 3.0.0.beta2"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "webmock"
end
