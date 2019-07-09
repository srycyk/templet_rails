$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "templet_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "templet_rails"
  spec.version     = TempletRails::VERSION
  spec.authors     = ["Stephen Rycyk"]
  spec.email       = ["stephen.rycyk@googlemail.com"]
  spec.homepage    = "http://github.com/srycyk/templet_rails"
  spec.summary     = "A framework for view rendering in Rails"
  spec.description = "Replaces Rails' view handling (ERB etc.) with an OO approach."
  spec.license     = "MIT"

=begin
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
=end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency "rails", "~> 5.2.3"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'rspec-rails'
  #spec.add_development_dependency 'factory_bot_rails', '4.10.0'
end
