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
        data = []
        @node.find_all("tbody tr").each do |tr|
          row_data = {}
          tr.find_all("td").each_with_index do |td, index|
            row_data[headers[index]] = td.text
          end
          data << row_data
        end
        data
      end

      def rows
        @node.find_all("tbody tr").map do |tr|
          Row.new(tr)
        end
      end
    end
  end
end
