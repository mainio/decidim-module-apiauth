# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Api
    describe DocumentationController do
      routes { Decidim::Api::Engine.routes }

      it_behaves_like "a force authentication controller", :get, :show
    end
  end
end
