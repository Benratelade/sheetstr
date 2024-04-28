# frozen_string_literal: true

module Users
  module Configuration
    class ConfigurationFormComponent < ViewComponent::Base
      def initialize(user_configuration:)
        super
        @user_configuration = user_configuration
      end
    end
  end
end
