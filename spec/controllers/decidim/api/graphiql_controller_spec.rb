# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Api
    describe GraphiQLController, type: :controller do
      controller Decidim::Api::GraphiQLController do
        def show; end
      end

      before do
        routes.draw do
          get "show" => "graphiql/rails/editors#show"
        end
      end

      it_behaves_like "a force authentication controller", :get, :show
    end
  end
end
