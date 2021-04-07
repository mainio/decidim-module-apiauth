# frozen_string_literal: true

module Decidim
  module Apiauth
    # This module is loaded if the API authentication is configured to be
    # necessary through:
    #   Decidim::Apiauth.configure do |config|
    #     config.force_api_authentication = true
    #   end
    module ForceApiAuthentication
      extend ActiveSupport::Concern

      included do
        before_action :ensure_api_authenticated!
      end

      private

      def ensure_api_authenticated!
        return unless Decidim::Apiauth.force_api_authentication
        return if user_signed_in?

        respond_to do |format|
          format.html do
            flash[:warning] = t("actions.login_before_access", scope: "decidim.core")
            store_location_for(:user, request.path)
            redirect_to decidim.new_user_session_path
          end
          format.json do
            render json: { error: "Access denied" }, status: :unauthorized
          end
        end
      end
    end
  end
end
