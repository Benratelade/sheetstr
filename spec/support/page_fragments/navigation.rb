# frozen_string_literal: true

module Support
  module PageFragments
    module Navigation
      def links
        nav = page.find("nav.navbar")
        links = {}
        nav.find(".navbar-nav").find_all(".nav-item").each do |link_item|
          links[link_item.text] = link_item.find("a")["href"]
        end

        links
      end

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
