# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::Configuration::ConfigurationFormComponent, type: :component do
  before do
    @user_configuration = double(
      "configuration",
      timezone_identifier: nil,
      user: double("user"),
      to_model: double(
        "to_model",
        model_name: double(
          name: "the model name",
          singular_route_key: "configurations",
          param_key: "id",
        ),
        persisted?: true,
      ),
    )
    @component = Users::Configuration::ConfigurationFormComponent.new(user_configuration: @user_configuration)
    allow(@component).to receive(:configurations_path).and_return("configuration_path")
  end

  it "renders a form for the configuration" do
    expect(@component).to receive(:configurations_path)
    render_inline(@component)

    form = page.find("form")
    expect(form["action"]).to eq("configuration_path")
  end

  it "renders a field for the timezone" do
    render_inline(@component)

    page.find_field("Timezone", type: "select")
  end

  it "renders a submit button" do
    render_inline(@component)

    expect(page).to have_button("Save")
  end
end
