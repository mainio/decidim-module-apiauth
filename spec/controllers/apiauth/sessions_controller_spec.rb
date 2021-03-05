# frozen_string_literal: true

require "spec_helper"
require "devise/jwt/test_helpers"

module Decidim
  module Apiauth
    describe SessionsController, type: :controller do
      routes { Decidim::Apiauth::Engine.routes }

      let(:organization) { create(:organization) }
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
        @request.env["decidim.current_organization"] = organization
      end

      describe "sign in" do
        it "returns jwt_token" do
          expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).not_to be_present
          post :create, params: params
          expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).to be_present
          parsed_response_body = JSON.parse(response.body)
          expect(parsed_response_body["jwt_token"]).to eq(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY])
        end
      end
    end
  end
end
