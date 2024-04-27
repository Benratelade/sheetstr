# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def not_found
    render("shared/errors/404", status: :not_found)
  end
end
