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
          descriptions = @list.find_all("[for='#{term['name']}']")
          data[term.text] = if descriptions.length == 1
                              descriptions.first.text
                            else
                              descriptions.map(&:text)
                            end
        end

        data
      end
    end
  end
end
