# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Api
    describe GraphiQLController, type: :controller do
      controller described_class do
        def show; end
      end

      before do
        routes.draw do
          get "show" => "decidim/api/graphiql#show"
        end
      end

      it_behaves_like "a force authentication controller", :get, :show
    end
  end
end
