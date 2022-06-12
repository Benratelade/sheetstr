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
end
