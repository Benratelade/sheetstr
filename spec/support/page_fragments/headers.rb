# frozen_string_literal: true

module Support
  module PageFragments
    module Headers
      def page_header
        page.find("#page-header").text
      end
    end
  end
end
