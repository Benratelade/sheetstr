# frozen_string_literal: true

module Support
  module Components
    class Table
      def initialize(node)
        @node = node
      end

      def headers
        @node.find_all("thead th").map(&:text)
      end

      def data
        @node.find_all("tbody tr").map do |tr|
          tr.find_al("td").map(&:text)
        end
      end
    end
  end
end
