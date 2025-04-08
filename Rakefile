# frozen_string_literal: true

require "decidim/dev/common_rake"

def change_test_cache_classes(path)
  test_config_path = "#{path}/config/environments/test.rb"
  text = File.read(test_config_path)
  new_contents = text.gsub(/config.cache_classes = true/, "config.cache_classes = false")
  File.open(test_config_path, "w") { |file| file << new_contents }
end

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rails decidim_apiauth:install:migrations")
    system("bundle exec rake db:migrate")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  path = "spec/decidim_dummy_app"
  change_test_cache_classes(path)
  install_module(path)
  Dir.chdir(path) do
    system("bundle exec rails generate decidim:apiauth:install --test-initializer true")
  end
end

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"
