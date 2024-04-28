# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def test_not_found
      raise(ActiveRecord::RecordNotFound)
    end
  end

  before do
    routes.draw { get "test_not_found" => "anonymous#test_not_found" }
  end

  context "When a record is not found" do
    it "renders a 404 page" do
      get :test_not_found

      expect(response).to render_template("shared/errors/404")
      expect(response).to have_http_status(:not_found)
    end
  end
end
