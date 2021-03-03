# frozen_string_literal: true

require "spec_helper"
require "devise/jwt/test_helpers"

module Decidim
  module Apiauth
    describe SessionsController, type: :controller do
      routes { Decidim::Apiauth::Engine.routes }

      let!(:organization) { create(:organization) }
      let(:email) { "admin@example.org" }
      let(:password) { "decidim123456" }
      let!(:user) { create(:user, :confirmed, :admin, organization: organization, email: email, password: password) }
      let(:params) do
        {
          user: {
            email: email,
            password: password
          }
        }
      end

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @request.env[::Warden::JWTAuth::Middleware::TokenDispatcher::ENV_KEY] = "warden-jwt_auth.token_dispatcher"
        @request.host = organization.host
      end

      it "signs in" do
        # allow(Decidim::User).to receive(:find_for_authentication).and_return(user)
        headers = { "Accept": "application/json", "Content-Type": "application/json" }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
        post :create, params: params # headers: auth_headers
        puts response.body
      end
    end
  end
end
