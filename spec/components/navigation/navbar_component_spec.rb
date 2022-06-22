# frozen_string_literal: true

require "rails_helper"

RSpec.describe Navigation::NavbarComponent, type: :component do
  before do 
    @component = Navigation::NavbarComponent.new
  end

  it "renders a nav" do
    render_inline(@component)

    expect(page).to have_css("nav.navbar div.container-fluid")
  end

  it "renders a logo for Sheetstr" do
    render_inline(@component)

    logo = page.find("nav div.container-fluid a.navbar-brand")
    expect(logo.text).to eq("Sheetstr")
    expect(logo["href"]).to eq("/")
  end

  it "renders a section for navbar actions" do
    render_inline(@component)

    actions_container = page.find("nav div.container-fluid div.navbar-actions")
    log_in_link = actions_container.find_link("Log in")
    sign_up_link = actions_container.find_link("Sign up")

    expect(log_in_link["href"]).to eq("/users/sign_in")
    expect(sign_up_link["href"]).to eq("/users/sign_up")
  end
end
