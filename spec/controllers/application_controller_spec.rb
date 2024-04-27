# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def test
      raise(ActiveRecord::RecordNotFound)
    end
  end

  context "when a record is not found" do
    before do
      routes.draw { get "test" => "anonymous#test" }
    end

    it "renders a 404 page" do
      get :test

      expect(response).to render_template("shared/errors/404")
      expect(response).to have_http_status(:not_found)
    end
  end
end
