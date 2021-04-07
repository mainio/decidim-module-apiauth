# frozen_string_literal: true

require "spec_helper"
require "devise/jwt/test_helpers"

module Decidim
  module Api
    describe QueriesController, type: :controller do
      routes { Decidim::Api::Engine.routes }

      let(:organization) { create :organization, force_users_to_authenticate_before_access_organization: true }
      let!(:user) { create(:user, :confirmed, :admin, organization: organization) }
      let(:query) { "{session{user{id nickname}}}" }

      context "without token" do
        before do
          request.env["decidim.current_organization"] = organization
        end

        it "redirects to sign in" do
          post :create, format: :json, params: { query: query }
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to("/users/sign_in")
          expect(response.body).to include("redirected")
        end
      end

      context "when request header includes token" do
        before do
          request.env["decidim.current_organization"] = organization
          headers = { "Accept": "application/json", "Content-Type": "application/json" }
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
          request.headers.merge!(auth_headers)
        end

        it "executes a query" do
          post :create, params: { query: query }
          parsed_response = JSON.parse(response.body)["data"]
          expect(parsed_response["session"]["user"]["id"].to_i).to eq(user.id)
          expect(parsed_response["session"]["user"]["nickname"]).to eq(user.nickname.prepend("@"))
        end
      end

      context "when using the force API authentication configuration" do
        let(:organization) { create :organization }
        let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

        it_behaves_like "a force authentication controller", :post, :create

        it "executes a query when authenticated" do
          allow(Decidim::Apiauth).to receive(:force_api_authentication).and_return(true)
          request.env["decidim.current_organization"] = organization
          request.headers.merge!(auth_headers)

          post :create, format: :json, params: { query: query }
          parsed_response = JSON.parse(response.body)["data"]
          expect(parsed_response["session"]["user"]["id"].to_i).to eq(user.id)
          expect(parsed_response["session"]["user"]["nickname"]).to eq(user.nickname.prepend("@"))
        end
      end
    end
  end
end
