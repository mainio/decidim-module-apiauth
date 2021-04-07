# frozen_string_literal: true

require "devise/jwt"

require_relative "apiauth/version"
require_relative "apiauth/engine"

module Decidim
  module Apiauth
    include ActiveSupport::Configurable

    # Public Setting that makes the API authentication necessary in order to
    # access it.
    config_accessor :force_api_authentication do
      false
    end
  end
end
