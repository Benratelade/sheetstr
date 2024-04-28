# frozen_string_literal: true

class UserConfiguration < ApplicationRecord
  belongs_to :user

  def setup_complete?
    timezone_identifier.present? && ActiveSupport::TimeZone.find_tzinfo(timezone_identifier).present?
  end
end
