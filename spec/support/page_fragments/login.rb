# frozen_string_literal: true

module Support
  module PageFragments
    module Login
      def login_as(user)
        visit "users/sign_in"
        login_card = page.find("div.login-card")
        login_card.fill_in("Email", with: user.email)
        login_card.fill_in("Password", with: user.password)
        login_card.click_button("Log in")
        wait_for { focus_on(Support::PageFragments::Flash).messages }.to eq(["Signed in successfully"])
      end
    end
  end
end
