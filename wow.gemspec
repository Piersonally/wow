$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wow/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wow"
  s.version     = Wow::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Wow."
  s.description = "TODO: Description of Wow."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", ">= 3.0.0.beta2"
end
