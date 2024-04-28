# frozen_string_literal: true

module Support
  module Controllers
    def stub_signed_in_user(user_double)
      allow(user_double).to receive(:timezone_identifier)
    end
  end
end