# frozen_string_literal: true

require "rails_helper"

RSpec.describe Utilities::Buttons::ButtonComponent, type: :component do
  before do
    @component = Utilities::Buttons::ButtonComponent.new(
      text: "Button text",
      link: "button-link",
    )
  end

  it "renders a link with the provided text and link" do
    render_inline(@component)

    button = page.find("a.btn", text: "Button text")
    expect(button["href"]).to eq("button-link")
    expect(button["role"]).to eq("button")
  end

  it "defaults to a primary button" do
    render_inline(@component)

    expect(page).to have_css("a.btn.btn-primary", text: "Button text")
  end

  it "sets no method by default" do
    render_inline(@component)

    link = page.find("a")
    expect(link["method"]).to be_nil
  end

  context "when the style is provided" do
    it "sets the style to primary if the style provided is :primary" do
      @component = Utilities::Buttons::ButtonComponent.new(
        text: "Button text",
        link: "button-link",
        style: "primary",
      )
      render_inline(@component)

      expect(page).to have_css("a.btn.btn-primary", text: "Button text")
    end

    it "sets the style to secondary if the style provided is :secondary" do
      @component = Utilities::Buttons::ButtonComponent.new(
        text: "Button text",
        link: "button-link",
        style: "secondary",
      )
      render_inline(@component)

      expect(page).to have_css("a.btn.btn-secondary", text: "Button text")
    end

    it "sets the style to danger if the style provided is :danger" do
      @component = Utilities::Buttons::ButtonComponent.new(
        text: "Button text",
        link: "button-link",
        style: "danger",
      )
      render_inline(@component)

      expect(page).to have_css("a.btn.btn-danger", text: "Button text")
    end

    it "throws an error if the style isn't recognised" do
      expect do
        @component = Utilities::Buttons::ButtonComponent.new(
          text: "Button text",
          link: "button-link",
          style: "nonna_the_above",
        )
        render_inline(@component)
      end.to raise_error("Unrecognized button style: nonna_the_above")
    end
  end

  context "when the method is provided" do
    it "sets the method to the provided method" do
      @component = Utilities::Buttons::ButtonComponent.new(
        text: "Button text",
        link: "button-link",
        method: "delete",
      )
      render_inline(@component)

      link = page.find("a")
      expect(link["data-method"]).to eq("delete")
    end

    it "raises an error if the method is unknown" do
      @component = Utilities::Buttons::ButtonComponent.new(
        text: "Button text",
        link: "button-link",
        method: "unknown_http_method",
      )

      expect do
        render_inline(@component)
      end.to raise_error("Unrecognized http method: unknown_http_method")
    end
  end
end
