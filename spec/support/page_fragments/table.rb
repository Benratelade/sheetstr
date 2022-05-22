# frozen_string_literal: true

module Support
  module PageFragments
    module Table
      def table(selector)
        page.find("table#timesheets-table")
      end
    end
  end
end