# frozen_string_literal: true

module Decidim
  module Apiauth
    class JwtBlacklist < ApplicationRecord
      include ::Devise::JWT::RevocationStrategies::Denylist

      self.table_name = "decidim_apiauth_jwt_blacklists"
    end
  end
end
