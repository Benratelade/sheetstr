# frozen_string_literal: true

module Users
  class ConfigurationsController < ApplicationController
    def edit
      @user_configuration = current_user.user_configuration || UserConfiguration.new
    end

    def update
      @user_configuration = current_user.user_configuration || UserConfiguration.new(user: current_user)

      @user_configuration.update!(user_configuration_params)

      redirect_to(new_timesheet_url)
    rescue ActiveRecord::RecordInvalid
      render :edit
    end

    private

    def user_configuration_params
      params.require(:user_configuration).permit(
        :timezone_identifier,
      ).to_h
    end
  end
end
