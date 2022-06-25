# frozen_string_literal: true

require "rails_helper"

describe "pages/home", type: :view do
  it "Says you're welcome to Sheetstr" do
    render

    expect(rendered).to have_css("h1", text: "Welcome to Sheetstr")
  end
end
