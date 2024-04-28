# frozen_string_literal: true

require "rails_helper"

describe "users/configurations/edit", type: :view do
  before do
    @user_configuration = double("the user configuration")
    allow(view).to receive(:render).and_call_original
  end

  it "Displays a title asking to select a timezone" do
    render

    expect(rendered).to have_css("h2#page-header", text: "Please select your timezone")
  end

  it "displays a user configuration form component" do
    configuration_form_component = double("a configuration form component")
    expect(Users::Configuration::ConfigurationFormComponent).to receive(:new).with(
      configuration: @user_configuration,
    ).and_return(configuration_form_component)
    expect(view).to receive(:render).with(configuration_form_component) { "A rendered configuration form component" }

    render

    expect(rendered).to have_content("A rendered configuration form component")
  end
end
