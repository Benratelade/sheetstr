# frozen_string_literal: true

require "rails_helper"

describe "layouts/application", type: :view do
  it "sets the viewport for bootstrap" do
    render

    expect(rendered).to have_css(
      "head meta[name='viewport'][content='width=device-width, initial-scale=1']",
      visible: false,
    )
  end

  it "sets a container around the body" do
    render

    expect(rendered).to have_css("body div.container-fluid")
  end

  it "renders an alert as a 'warning' if the flash type is 'alert'" do
    allow(controller).to receive(:flash).and_return(
      alert: "Some alert message",
    )

    render

    expect(rendered).to have_css("div.flash.alert.alert-danger", text: "Some alert message")
  end

  it "renders an alert with the class 'success' when it's just a notice" do
    allow(controller).to receive(:flash).and_return(
      notice: "Some notice message",
    )

    render

    expect(rendered).to have_css("div.flash.alert.alert-success", text: "Some notice message")
  end

  it "renders a Navbar Component" do
    navbar_component = double("A navbar component")
    current_user = double("the current user")
    allow(view).to receive(:render).and_call_original
    allow(view).to receive(:current_user).and_return(current_user)
    expect(Navigation::NavbarComponent).to receive(:new).with(user: current_user).and_return(navbar_component)
    expect(view).to receive(:render).with(navbar_component) { "the rendered navbar component" }

    render

    expect(rendered).to have_content("the rendered navbar component")
  end
end
