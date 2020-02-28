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

        app.middleware.use Warden::JWTAuth::Middleware
      end

      config.to_prepare do
        # Model extensions
        Decidim::User.send(:include, Decidim::Apiauth::ApiAuthentication)
      end

      config.after_initialize do
        Rails.application.reload_routes!

        # There is some problem setting these configurations to Devise::JWT,
        # so send them directly to the Warden module.
        #
        # See:
        # https://github.com/waiting-for-dev/devise-jwt/issues/159
        Warden::JWTAuth.configure do |jwt|
          defaults = Devise::JWT::DefaultsGenerator.call

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
