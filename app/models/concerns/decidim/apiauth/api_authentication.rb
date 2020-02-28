# frozen_string_literal: true

module Decidim
  module Apiauth
    module ApiAuthentication
      extend ActiveSupport::Concern

      included do
        devise :jwt_authenticatable,
               jwt_revocation_strategy: JwtBlacklist
      end
    end
  end
end
