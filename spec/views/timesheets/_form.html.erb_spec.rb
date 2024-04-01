# frozen_string_literal: true

require "rails_helper"

describe "timesheets/_form", type: :view do
  before do
    @timesheet = double(
      "A timesheet",
      to_model: double(
        "to_model",
        model_name: double(
          "model_name",
          name: Timesheet,
          route_key: "timesheets",
          param_key: "timesheet",
          i18n_key: "id",
        ),
        start_date: Date.parse("Jan 31 2022"),
        end_date: Date.parse("Feb 06 2022"),
        persisted?: false,
      ),
    )
  end

  it "Renders a form for the Timesheet" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_css("form")
  end

  it "displays the start and end dates" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_field("timesheet_start_date", with: "2022-01-31")
    expect(rendered).to have_field("timesheet_end_date", with: "2022-02-06")
  end

  it "displays a save button" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_button("Save")
  end
end
