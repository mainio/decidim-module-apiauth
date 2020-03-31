# frozen_string_literal: true

module Decidim
  module Apiauth
    class SessionsController < ::Devise::SessionsController
      skip_before_action :verify_authenticity_token

      respond_to :json

      private

      def after_sign_in_path_for(_resource_or_scope)
        nil
      end

      def respond_with(resource, _opts = {})
        if request.env[::Warden::JWTAuth::Middleware::TokenDispatcher::ENV_KEY]
          # Some systems (that's you Microsoft Power Automate (Flow)) may be
          # parsing off the headers which makes it difficult for the API users
          # to get the bearer token. This allows them to get it from the request
          # body instead.
          return render json: resource.serializable_hash.merge(
            jwt_token: request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]
          )
        end

        render json: resource
      end

      def respond_to_on_destroy
        head :ok
      end

      def render_resource(resource)
        if resource.errors.empty?
          render json: resource
        else
          validation_error(resource)
        end
      end

      def validation_error(resource)
        render json: {
          errors: [
            {
              status: "400",
              title: "Bad Request",
              detail: resource.errors,
              code: "100"
            }
          ]
        }, status: :bad_request
      end
    end
  end
end
