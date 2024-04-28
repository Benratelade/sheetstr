# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::ConfigurationsController, type: :controller do
  # include Devise::Test::IntegrationHelpers

  before do
    @user = double("user", user_configuration: nil)
    allow(controller).to receive(:current_user).and_return(@user)

    @new_user_configuration = double("user configuration", update!: nil)
    allow(UserConfiguration).to receive(:new).and_return(@new_user_configuration)
  end

  describe "GET#edit" do
    context "the user has a configuration" do
      before do
        @existing_user_configuration = double("user configuration")
        allow(@user).to receive(:user_configuration).and_return(@existing_user_configuration)
      end

      it "assigns the existing user_configuration" do
        get(:edit)

        expect(assigns(:user_configuration)).to eq(@existing_user_configuration)
      end
    end

    context "the user does NOT have a configuration" do
      before do
        @new_user_configuration = double("user configuration")
        allow(@user).to receive(:user_configuration).and_return(nil)
        allow(UserConfiguration).to receive(:new).and_return(@new_user_configuration)
      end

      it "creates a new user_configuration and assigns it" do
        get(:edit)

        expect(assigns(:user_configuration)).to eq(@new_user_configuration)
      end
    end
  end

  describe "PUT#update" do
    it "redirects to timesheets/new" do
      put(
        :update,
        params: {
          user_configuration: {
            timezone_identifier: "timezone identifier",
            foo: "bar",
          },
        },
      )

      expect(response).to redirect_to(controller: "/timesheets", action: :new)
    end

    context "the user has a configuration" do
      before do
        @existing_user_configuration = double("user configuration")
        allow(@user).to receive(:user_configuration).and_return(@existing_user_configuration)
      end

      it "saves the configuration for the user" do
        expect(@existing_user_configuration).to receive(:update!).with(
          { "timezone_identifier" => "timezone identifier" },
        )

        put(
          :update,
          params: {
            user_configuration: {
              timezone_identifier: "timezone identifier",
              foo: "bar",
            },
          },
        )
      end
    end

    context "the user does NOT have a configuration" do
      it "saves the new configuration for the user" do
        expect(UserConfiguration).to receive(:new).with(user: @user)
        expect(@new_user_configuration).to receive(:update!).with(
          { "timezone_identifier" => "timezone identifier" },
        )

        put(
          :update,
          params: {
            user_configuration: {
              timezone_identifier: "timezone identifier",
              foo: "bar",
            },
          },
        )
      end
    end

    context "The configuration is invalid" do
      before do
        allow(@new_user_configuration).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      it "assigns the configuration and re-renders the edit screen" do
        put(
          :update,
          params: {
            user_configuration: {
              timezone_identifier: "timezone identifier",
              foo: "bar",
            },
          },
        )

        expect(assigns(:user_configuration)).to eq(@new_user_configuration)
        expect(response).to render_template(:edit)
      end
    end
  end
end
