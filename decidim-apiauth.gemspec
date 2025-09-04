# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/apiauth/version"

Gem::Specification.new do |spec|
  spec.metadata = { "rubygems_mfa_required" => "true" }
  spec.name = "decidim-apiauth"
  spec.version = Decidim::Apiauth.version
  spec.required_ruby_version = ">= 3.1"
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

  spec.add_dependency "decidim-api", Decidim::Apiauth.decidim_version
  spec.add_dependency "decidim-core", Decidim::Apiauth.decidim_version
  spec.add_dependency "devise-jwt", "~> 0.11.0"

  spec.add_development_dependency "decidim-dev", Decidim::Apiauth.decidim_version
end
