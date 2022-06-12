# frozen_string_literal: true

module Support
  module PageFragments
    module Flash
      def flash
        page.find(".flash")
      end

      def messages
        flash.text.split(".").map(&:strip)
      end
    end
  end
end
