# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingController, type: :controller do
  describe "GET#onboard" do
    before do
      @user = double("user", setup_complete?: nil)
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it "redirects to configurations#edit if the user's setup is NOT complete" do
      allow(@user).to receive(:setup_complete?).and_return(false)

      get :onboard

      expect(response).to redirect_to(controller: "configurations", action: "edit")
    end

    it "redirects to timesheets#new if the user's setup IS complete" do
      allow(@user).to receive(:setup_complete?).and_return(true)

      get :onboard

      expect(response).to redirect_to(controller: "timesheets", action: "new")
    end
  end
end
