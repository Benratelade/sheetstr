# frozen_string_literal: true

class OnboardingController < ApplicationController
  def onboard
    if current_user.setup_complete?
      redirect_to new_timesheet_path
    else
      redirect_to edit_configurations_path
    end
  end
end
