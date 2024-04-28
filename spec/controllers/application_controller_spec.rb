# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def test_not_found
      raise(ActiveRecord::RecordNotFound)
    end

    def test_timezone
      render plain: Time.zone
    end
  end

  before do
    routes.draw do
      get "test_not_found" => "anonymous#test_not_found"
      get "test_timezone" => "anonymous#test_timezone"
    end
  end

  context "When a record is not found" do
    it "renders a 404 page" do
      get :test_not_found

      expect(response).to render_template("shared/errors/404")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "timezone" do
    before do
      @current_user = double("user", timezone_identifier: nil)
      allow(controller).to receive(:current_user).and_return(@current_user)
    end

    context "When the user is not logged in" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it "returns UTC timezone" do
        get(:test_timezone)

        expect(response.body).to eq("(GMT+00:00) UTC")
      end
    end

    context "When the current user has a Sydney timezone" do
      it "sets the timezone to Sydney" do
        allow(@current_user).to receive(:timezone_identifier).and_return("Sydney")

        get(:test_timezone)

        expect(response.body).to eq("(GMT+10:00) Sydney")
      end
    end

    context "When the current user has a Paris timezone" do
      it "sets the timezone to Melbourne" do
        allow(@current_user).to receive(:timezone_identifier).and_return("Melbourne")

        get(:test_timezone)

        expect(response.body).to eq("(GMT+10:00) Melbourne")
      end
    end
  end
end
