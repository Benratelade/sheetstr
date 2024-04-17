# frozen_string_literal: true

module Support
  module PageFragments
    class DescriptionList
      def initialize(list)
        @list = list
      end

      def summary
        data = {}
        terms = @list.find_all("dt")
        terms.each do |term|
          data[term.text] = @list.find_all("[for='#{term['name']}']").map(&:text)
        end
        data
      end
    end
  end
end
