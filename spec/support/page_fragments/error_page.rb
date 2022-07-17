# frozen_string_literal: true

module Support
  module PageFragments
    module ErrorPage
      def error_code
        page.find("h1.error-code").text
      end
    end
  end
end
