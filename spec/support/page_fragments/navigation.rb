# frozen_string_literal: true

module Support
  module PageFragments
    module Navigation
      def actions
        nav = page.find("nav.navbar")
        actions = {}
        nav.find(".navbar-actions").find_all("a").each do |link|
          actions[link.text] = link["href"]
        end

        actions
      end
    end
  end
end
