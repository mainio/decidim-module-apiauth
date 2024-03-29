# frozen_string_literal: true

module Decidim
  module Apiauth
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Apiauth

      routes do
        devise_scope :user do
          post "sign_in", to: "sessions#create", as: :user_session
          delete "sign_out", to: "sessions#destroy", as: :destroy_user_session
        end
      end

      initializer "decidim_apiauth.mount_routes" do
        Decidim::Api::Engine.routes do
          mount Decidim::Apiauth::Engine => "/"
        end
      end

      initializer "decidim_apiauth.configure" do |app|
        app.initializers.find { |a| a.name == "devise-jwt-middleware" }.context_class.instance.initializers.reject! { |a| a.name == "devise-jwt-middleware" }
      end

      initializer "decidim_apiauth_customizations", after: "decidim.action_controller" do
        # To be compatibale with Turbo, from Devise v.4.9.0 on, devise keep error status for validation as :ok, and sets
        # the redirect_status as :found. However, these configuration options is devised to change this behavior as
        # needed(for more information refer to https://github.com/heartcombo/devise/blob/v4.9.0/CHANGELOG.md#490---2023-02-17):
        ActiveSupport.on_load(:devise_failure_app) do
          Devise.setup do |config|
            config.responder.error_status = :forbidden
          end
        end

        config.to_prepare do
          # Model extensions
          Decidim::User.include Decidim::Apiauth::ApiAuthentication

          # Add a concern to the API controllers that adds the force login logic
          # when configured through `Decidim::Apiauth.force_api_authentication`.
          Decidim::Api::ApplicationController.include(
            Decidim::Apiauth::ForceApiAuthentication
          )
          # The GraphiQLController is not extending
          # Decidim::Api::ApplicationController which is why this needs to be
          # separately loaded for that too.
          Decidim::Api::GraphiQLController.include(
            Decidim::Apiauth::ForceApiAuthentication
          )
        end
      end

      config.after_initialize do
        Rails.application.reload_routes!

        # There is some problem setting these configurations to Devise::JWT,
        # so send them directly to the Warden module.
        #
        # See:
        # https://github.com/waiting-for-dev/devise-jwt/issues/159
        Warden::JWTAuth.configure do |jwt|
          defaults = ::Devise::JWT::DefaultsGenerator.call

          jwt.mappings = defaults[:mappings]
          jwt.secret = Rails.application.secrets.secret_key_jwt
          jwt.dispatch_requests = [
            ["POST", %r{^/sign_in$}]
          ]
          jwt.revocation_requests = [
            ["DELETE", %r{^/sign_out$}]
          ]
          jwt.revocation_strategies = defaults[:revocation_strategies]
          jwt.expiration_time = 1.day.to_i
          jwt.aud_header = "JWT_AUD"
        end
      end
    end
  end
end
