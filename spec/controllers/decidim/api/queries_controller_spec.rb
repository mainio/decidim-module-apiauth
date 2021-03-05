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
        it "redirects to sign in" do
          post :create, params: { query: query }
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
    end
  end
end
