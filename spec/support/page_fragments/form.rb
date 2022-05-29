# frozen_string_literal: true

module Support
  module PageFragments
    module Form
      def form(selector = nil)
        selector ||= "form"
        Support::Components::Form.new(page.find(selector))
      end
    end
  end
end
