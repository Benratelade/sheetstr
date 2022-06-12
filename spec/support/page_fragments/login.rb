# frozen_string_literal: true

module Support
  module PageFragments
    module Login
      def login_as(user)
        visit "users/sign_in"
        fill_in("Email", with: user.email)
        fill_in("Password", with: user.password)
        click_on("Log in")
        wait_for { focus_on(Support::PageFragments::Flash).messages }.to eq(["Signed in successfully"])
      end
    end
  end
end
