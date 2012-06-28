$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "slab/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.date        = '2012-06-28'
  s.name        = "slab"
  s.version     = Slab::VERSION
  s.authors     = ['Matthias Grosser']
  s.email       = ['mtgrosser@gmx.net']
  s.homepage    = 'http://rubygems.org/gems/slab'
  s.summary     = 'Core extensions to build Rails upon'
  s.description = 'Extensions for Ruby base classes'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activesupport", "~> 3.2.3"
end
