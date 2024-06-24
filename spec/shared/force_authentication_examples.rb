# frozen_string_literal: true

shared_examples "a force authentication controller" do |method, action|
  let(:user) { create(:user, :confirmed, organization:) }
  let!(:organization) { create(:organization) }

  before do
    request.env["decidim.current_organization"] = organization
  end

  context "without user" do
    it "responds with unauthorized status" do
      send(method, action)
      expect(response).to have_http_status(:ok)
    end

    context "when API authentication is forced" do
      before do
        allow(Decidim::Apiauth).to receive(:force_api_authentication).and_return(true)
      end

      it "responds with redirect status for HTML requests" do
        send(method, action)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/users/sign_in")
      end

      it "responds with unauthorized status for JSON requests" do
        send(method, action, format: :json)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "when user is signed in and API authentication is forced" do
    before do
      sign_in user

      allow(Decidim::Apiauth).to receive(:force_api_authentication).and_return(true)
    end

    it "responds normally for HTML requests" do
      send(method, action)
      expect(response).to have_http_status(:ok)
    end
  end
end
