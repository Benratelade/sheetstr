# frozen_string_literal: true

module Support
  module Components
    class Form
      def initialize(node)
        @node = node
      end

      def labels
        @node.find_all("label").map(&:text)
      end

      def value_for(label)
        @node.find_field(label).value
      end

      def values
        values = []
        labels = @node.find_all("label")
        labels.each do |label|
          input = @node.find("input##{label['for']}")
          values << { label.text => input.value }
        end

        values
      end
    end
  end
end
