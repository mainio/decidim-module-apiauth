# frozen_string_literal: true

require "rails/generators/base"

module Decidim
  module Apiauth
    module Generators
      class InstallGenerator < Rails::Generators::Base
        def enable_authentication
          secret = SecureRandom.hex(64)
          secrets_path = Rails.application.root.join("config", "secrets.yml")

          index = nil
          i = 0
          lines = IO.readlines(secrets_path).map do |line|
            index = i if line =~ /^test:/
            i += 1
            line
          end
          unless lines[index + 3].include?("secret_key_jwt")
            lines.insert(index + 3, "  secret_key_jwt: #{secret}")
            File.open(secrets_path, "w") do |file|
              file.puts lines
            end
          end
        end
      end
    end
  end
end
