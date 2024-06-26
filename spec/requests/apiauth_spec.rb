# frozen_string_literal: true

require "spec_helper"

RSpec.describe "ApiAuthentication" do
  let(:sign_in_path) { "/api/sign_in" }
  let(:sign_out_path) { "/api/sign_out" }

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
  let(:hacker_email) { "hacker@example.org" }
  let(:invalid_params) do
    {
      user: {
        email: hacker_email,
        password: "maga2020"
      }
    }
  end
  let(:query) { "{session{user{id nickname}}}" }

  before do
    host! organization.host
  end

  it "signs in" do
    post(sign_in_path, params:)
    expect(response.headers["Authorization"]).to be_present
    expect(response.body["jwt_token"]).to be_present
    parsed_response_body = response.parsed_body
    expect(response.headers["Authorization"].split[1]).to eq(parsed_response_body["jwt_token"])
  end

  it "renders resource when invalid credentials" do
    post sign_in_path, params: invalid_params
    parsed_response_body = response.parsed_body
    expect(parsed_response_body["email"]).to eq(hacker_email)
    expect(parsed_response_body["jwt_token"]).not_to be_present
  end

  it "signs out" do
    post(sign_in_path, params:)
    expect(response).to have_http_status(:ok)
    authorzation = response.headers["Authorization"]
    orginal_count = Decidim::Apiauth::JwtBlacklist.count
    delete sign_out_path, params: {}, headers: { HTTP_AUTHORIZATION: authorzation }
    expect(Decidim::Apiauth::JwtBlacklist.count).to eq(orginal_count + 1)
  end

  context "when signed in" do
    before do
      post sign_in_path, params:
    end

    it "can use token to post to api" do
      authorzation = response.headers["Authorization"]
      post "/api", params: { query: }, headers: { HTTP_AUTHORIZATION: authorzation }
      parsed_response = response.parsed_body["data"]
      expect(parsed_response["session"]["user"]["id"].to_i).to eq(user.id)
      expect(parsed_response["session"]["user"]["nickname"]).to eq(user.nickname.prepend("@"))
    end
  end
end
