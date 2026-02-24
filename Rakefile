# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    # Disable Spring to evade reloading error.
    # (Spring reloads, and therefore needs the application to have reloading enabled.) This is disabled by default.

    env = { "DISABLE_SPRING" => "1", "RAILS_ENV" => "test" }
    system(env, "bundle exec rails decidim_apiauth:install:migrations")
    system(env, "bundle exec rake db:migrate")
    system(env, "bundle exec rails generate decidim:apiauth:install --test-initializer true")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  path = "spec/decidim_dummy_app"
  install_module(path)
end

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"
