# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/apiauth/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-apiauth"
  spec.version = Decidim::Apiauth::VERSION
  spec.required_ruby_version = ">= 2.7"
  spec.authors = ["Antti Hukkanen"]
  spec.email = ["antti.hukkanen@mainiotech.fi"]

  spec.summary = "Provides API token based authentication for Decidim."
  spec.description = "Adds token based authentication for Decidim's API."
  spec.homepage = "https://github.com/mainio/decidim-module-apiauth"
  spec.license = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-api", Decidim::Apiauth::DECIDIM_VERSION
  spec.add_dependency "decidim-core", Decidim::Apiauth::DECIDIM_VERSION
  spec.add_dependency "devise", "~> 4.8.1"
  spec.add_dependency "devise-jwt", "~> 0.7.0"
  spec.add_dependency "dry-configurable", "~> 0.12.1"
  spec.add_dependency "dry-container", "~> 0.8.0"

  spec.add_development_dependency "decidim-dev", Decidim::Apiauth::DECIDIM_VERSION
end
