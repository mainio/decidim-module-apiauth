# frozen_string_literal: true

require "spec_helper"
require "devise/jwt/test_helpers"

module Decidim
  module Apiauth
    describe SessionsController do
      routes { Decidim::Apiauth::Engine.routes }

      let(:organization) { create(:organization) }
      let(:email) { "admin@example.org" }
      let(:password) { "decidim123456789" }
      let!(:user) { create(:user, :confirmed, :admin, organization:, email:, password:) }
      let(:params) do
        {
          user: {
            email:,
            password:
          }
        }
      end
      let(:invalid_params) do
        {
          user: {
            email:,
            password: "maga2020"
          }
        }
      end

      before do
        @request.env["devise.mapping"] = ::Devise.mappings[:user]
        @request.env[::Warden::JWTAuth::Middleware::TokenDispatcher::ENV_KEY] = "warden-jwt_auth.token_dispatcher"
        @request.env["decidim.current_organization"] = organization
      end

      describe "sign in" do
        it "returns jwt_token when credentials are valid" do
          expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).not_to be_present
          post(:create, params:)
          expect(response).to have_http_status(:ok)
          expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).to be_present
          parsed_response_body = response.parsed_body
          expect(parsed_response_body["jwt_token"]).to eq(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY])
        end

        it "returns 403 when credentials are invalid" do
          post :create, params: invalid_params
          expect(response).to have_http_status(:forbidden)
          expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).not_to be_present
        end

        it "renders resource witout jwt_token in body when Tokendispatcher::ENV_KEY is nil" do
          @request.env[::Warden::JWTAuth::Middleware::TokenDispatcher::ENV_KEY] = nil
          post(:create, params:)
          expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).to be_present
          parsed_response_body = response.parsed_body
          expect(parsed_response_body.has_key?("jwt_token")).to be(false)
        end

        context "with normal sign in" do
          before do
            allow(::Decidim::Apiauth).to receive(:force_api_authentication).and_return(false)
          end

          it "returns jwt_token when credentials are valid" do
            expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).not_to be_present
            post(:create, params:)
            expect(response).to have_http_status(:ok)
            expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).to be_present
            parsed_response_body = response.parsed_body
            expect(parsed_response_body["jwt_token"]).to eq(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY])
          end

          it "returns 403 when credentials are invalid" do
            post :create, params: invalid_params
            expect(response).to have_http_status(:forbidden)
            expect(request.env[::Warden::JWTAuth::Hooks::PREPARED_TOKEN_ENV_KEY]).not_to be_present
          end
        end
      end
    end
  end
end
