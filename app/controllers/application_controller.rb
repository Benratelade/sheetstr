# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  around_action :set_time_zone

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def not_found
    render("shared/errors/404", status: :not_found)
  end

  def set_time_zone
    if current_user
      Time.use_zone(current_user.timezone_identifier) { yield }
    else 
      yield
    end
  end
end
