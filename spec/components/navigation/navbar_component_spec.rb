# frozen_string_literal: true

require "rails_helper"

RSpec.describe Navigation::NavbarComponent, type: :component do
  before do
    @component = Navigation::NavbarComponent.new(user: nil)
  end

  it "renders a nav" do
    render_inline(@component)

    expect(page).to have_css("nav.navbar div.container-fluid.justify-content-start")
  end

  it "renders a logo for Sheetstr" do
    render_inline(@component)

    logo = page.find("nav div.container-fluid a.navbar-brand")
    expect(logo.text).to eq("Sheetstr")
    expect(logo["href"]).to eq("/")
  end

  context "when there is no user" do
    it "renders a section for navbar actions with links to log in or sign up" do
      render_inline(@component)

      actions_container = page.find("nav div.container-fluid div.navbar-actions")
      log_in_link = actions_container.find_link("Log in")
      sign_up_link = actions_container.find_link("Sign up")

      expect(log_in_link["href"]).to eq("/users/sign_in")
      expect(sign_up_link["href"]).to eq("/users/sign_up")
    end

    it "does NOT render a section for navbar items" do
      render_inline(@component)

      expect(page).not_to have_css("ul.navbar-nav")
    end
  end

  context "when there is a current_user" do
    before do
      @user = double("a logged in user")
      @component = Navigation::NavbarComponent.new(user: @user)
    end

    it "renders a section for navbar items" do
      render_inline(@component)

      expect(page).to have_css("nav div.container-fluid ul.navbar-nav.flex-grow-1")
    end

    it "renders a link to list of timesheets inside the navbar items" do
      render_inline(@component)

      navbar_container = page.find("nav div.container-fluid ul.navbar-nav")
      expect(navbar_container).to have_css("li.nav-item a.nav-link[href='/timesheets']")
    end

    it "renders a section for navbar actions with a logout link" do
      render_inline(@component)

      actions_container = page.find("nav div.container-fluid div.navbar-actions")
      log_out_link = actions_container.find_link("Log out")

      expect(log_out_link["href"]).to eq("/users/sign_out")
      expect(log_out_link["data-method"]).to eq("delete")
    end
  end
end
