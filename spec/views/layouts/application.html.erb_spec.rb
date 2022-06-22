# frozen_string_literal: true

require "rails_helper"

describe "layouts/application", type: :view do
  it "renders all alert flash messages in a bootstrap alert" do
    allow(controller).to receive(:flash).and_return(
      danger: "Some alert messages",
    )

    render

    expect(rendered).to have_css("div.flash.alert.alert-danger", text: "Some alert messages")
  end

  it "renders a Navbar Component" do
    navbar_component = double("A navbar component")
    allow(view).to receive(:render).and_call_original
    expect(Navigation::NavbarComponent).to receive(:new).and_return(navbar_component)
    expect(view).to receive(:render).with(navbar_component).and_return("a navbar component")

    render

    expect(rendered).to have_content("a navbar component")
  end
end
