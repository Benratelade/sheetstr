# frozen_string_literal: true

module LineItems
  class LineItemSummaryComponent < ViewComponent::Base
    def initialize(item)
      super
      @item = item
    end
  end
end
