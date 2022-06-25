# frozen_string_literal: true

module Navigation
  class NavbarComponent < ViewComponent::Base
    def initialize(user: nil)
      super
      @user = user
    end
  end
end
