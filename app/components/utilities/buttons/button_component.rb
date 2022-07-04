# frozen_string_literal: true

module Utilities
  module Buttons
    class ButtonComponent < ViewComponent::Base
      SUPPORTED_STYLES = %w[primary secondary danger].freeze

      def initialize(text:, link:, style: "primary", method: nil)
        super
        @text = text
        @link = link
        @style = style
        @method = method
      end

      def set_style
        raise "Unrecognized button style: #{@style}" unless SUPPORTED_STYLES.include?(@style)

        @style
      end

      def set_method
        return nil if @method.blank?
        raise "Unrecognized http method: #{@method}" unless %w[get delete put patch post].include?(@method)

        @method
      end
    end
  end
end
