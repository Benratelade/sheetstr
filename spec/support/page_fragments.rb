# frozen_string_literal: true

module Support
  module PageFragments
    def focus_on(mod)
      rspec_example = self
      rspec_example.extend(mod)
      rspec_example
    end
  end
end
