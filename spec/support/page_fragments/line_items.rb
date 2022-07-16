# frozen_string_literal: true

module Support
  module PageFragments
    module LineItems
      def view(line_item)
        page.find("[href*=\"#{line_item.id}\"]", text: "View").click
      end

      def edit(line_item)
        page.find("[href*=\"#{line_item.id}\"]", text: "Edit").click
      end
    end
  end
end
