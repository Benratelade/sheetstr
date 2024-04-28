# frozen_string_literal: true

module LineItems
  class LineItemSummaryComponent < ViewComponent::Base
    def initialize(item:, timezone_identifier:)
      super
      @item = item
      @timezone_identifier = timezone_identifier
    end
  end
end
