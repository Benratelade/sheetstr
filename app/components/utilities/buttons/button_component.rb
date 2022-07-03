# frozen_string_literal: true

module Utilities
  module Buttons
    class ButtonComponent < ViewComponent::Base
      SUPPORTED_STYLES = %w[primary secondary].freeze

      def initialize(text:, link:, style: "primary")
        super
        @text = text
        @link = link
        @style = style
      end

      def set_style
        raise "Unrecognized button style: #{@style}" unless SUPPORTED_STYLES.include?(@style)

        @style
      end
    end
  end
end
