# frozen_string_literal: true

require "rails_helper"

describe "timesheets/line_items/new", type: :view do
  before do
    @timesheet = double(
      "A timesheet",
      id: "timesheet-id",
      to_model: double(
        "to_model",
        model_name: double(
          "model_name",
          name: Timesheet,
          route_key: "timesheets",
          param_key: "timesheet",
          singular_route_key: "timesheet",
          i18n_key: "id",
        ),
        persisted?: true,
        to_param: "timesheet-id",
      ),
    )
    stub_template("timesheets/line_items/_form.html.erb" => "The line item form")
  end

  it "renders a title" do
    render

    expect(rendered).to have_css("h2", text: "Add item")
  end

  it "Displays a form for the new item" do
    render

    expect(view).to render_template(partial: "_form", locals: { timesheet: @timesheet, line_item: @line_item })
    expect(rendered).to have_content("The line item form")
  end
end
