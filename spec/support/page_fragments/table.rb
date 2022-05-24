# frozen_string_literal: true

module Support
  module PageFragments
    module Table
      def table(selector)
        Support::Components::Table.new(page.find(selector))
      end
    end
  end
end
