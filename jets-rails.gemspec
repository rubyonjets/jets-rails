$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "jets_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jets-rails"
  s.version     = JetsRails::VERSION
  s.authors     = ["Tung Nguyen"]
  s.email       = ["tongueroo@gmail.com"]
  s.homepage    = "https://github.com/tongueroo/jets-rails"
  s.summary     = "Jets Mega Mode Rails Support"
  s.description = "Reconfigures the Rails application and injects the necessary changes to run the rack application on AWS Lambda. Meant to be used in conjunction with Jets. Not meant to be used standalone."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5"

  s.add_development_dependency "sqlite3"
end
