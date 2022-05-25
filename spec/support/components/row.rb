# frozen_string_literal: true

module Support
  module Components
    class Row
      def initialize(node)
        @node = node
      end

      def go_to(label)
        @node.click_link(label)
      end
    end
  end
end
