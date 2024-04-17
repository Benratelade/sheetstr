# frozen_string_literal: true

module Utilities
  class DescriptionListComponent < ViewComponent::Base
    def initialize(values_hash)
      super
      @values_hash = values_hash
    end
  end
end
