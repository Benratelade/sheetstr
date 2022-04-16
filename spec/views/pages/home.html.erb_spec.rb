# frozen_string_literal: true

require "rails_helper"

describe "pages/home", type: :view do
  it "renders a section for available actions" do
    render

    expect(rendered).to have_css("div.login-options")
  end

  it "renders a button to log in and a button to sign up" do
    render

    page = Capybara.string(rendered)

    log_in_button = page.find("a[data-test='log-in-button']")
    sign_up_button = page.find("a[data-test='sign-up-button']")
    
    expect(log_in_button["href"]).to eq("/users/sign_in")
    expect(sign_up_button["href"]).to eq("/users/sign_up")
  end
end
