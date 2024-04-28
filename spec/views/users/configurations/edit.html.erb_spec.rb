# frozen_string_literal: true

require "rails_helper"

describe "users/configurations/edit", type: :view do
  before do
    @user_configuration = double("the user configuration")
    allow(view).to receive(:render).and_call_original

    @configuration_form_component = double("a configuration form component")
    allow(Users::Configuration::ConfigurationFormComponent).to receive(:new).and_return(@configuration_form_component)
    allow(view).to receive(:render).with(@configuration_form_component) { "A rendered configuration form component" }
  end

  it "Displays a title asking to select a timezone" do
    render

    expect(rendered).to have_css("h2#page-header", text: "Please select your timezone")
  end

  it "displays a user configuration form component" do
    expect(Users::Configuration::ConfigurationFormComponent).to receive(:new).with(
      user_configuration: @user_configuration,
    )
    expect(view).to receive(:render).with(@configuration_form_component)

    render

    expect(rendered).to have_content("A rendered configuration form component")
  end
end
