# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "generators/decidim/apiauth/install_generator"

describe Decidim::Apiauth::Generators::InstallGenerator do
  let(:secrets_path) { Rails.application.root.join("config", "secrets.yml") }
  let(:options) { { test_initializer: true } }

  it "adds secret_key_jwt to the secrets.yml file" do
    # rubocop:disable Rspec/SubjectStub
    allow(subject).to receive(:options).and_return(options)
    # rubocop:enable Rspec/SubjectStub

    subject.add_jwt_secret
    secrets = YAML.safe_load(File.read(secrets_path), [], [], true)

    expect(secrets["test"]["secret_key_jwt"]).to be_present
  end
end
