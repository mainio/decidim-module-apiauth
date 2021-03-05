# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Api authentication", type: :request do
  let(:sign_in_path) { "/api/sign_in" }

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
  let(:query) { "{session{user{id nickname}}}" }

  before do
    host! organization.host
  end

  it "signs in" do
    post sign_in_path, params: params
    expect(response.headers["Authorization"]).to be_present
    expect(response.body["jwt_token"]).to be_present
    parsed_response_body = JSON.parse(response.body)
    expect(response.headers["Authorization"].split[1]).to eq(parsed_response_body["jwt_token"])
  end

  it "can use token to post to api" do
    post sign_in_path, params: params
    authorzation = response.headers["Authorization"]
    post "/api", params: { query: query }, headers: { "HTTP_AUTHORIZATION": authorzation }
    parsed_response = JSON.parse(response.body)["data"]
    expect(parsed_response["session"]["user"]["id"].to_i).to eq(user.id)
    expect(parsed_response["session"]["user"]["nickname"]).to eq(user.nickname.prepend("@"))
  end
end
