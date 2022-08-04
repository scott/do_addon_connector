require_relative "lib/do_addon_connector/version"

Gem::Specification.new do |spec|
  spec.name        = "do_addon_connector"
  spec.version     = DoAddonConnector::VERSION
  spec.authors     = ["Scott Miller"]
  spec.email       = ["scott@helpy.io"]
  spec.homepage    = "https://github.com/scott/do_addon_connector"
  spec.summary     = "This adds the endpoints you need to connect with the DigitalOcean Addons."
  spec.description = "Adds endpoints for connecting to the DO marketplace."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 7", ">= 6"
  spec.add_dependency "http"
end
