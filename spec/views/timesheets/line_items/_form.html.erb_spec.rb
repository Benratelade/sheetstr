# frozen_string_literal: true

require "rails_helper"

describe "timesheets/line_items/_form", type: :view do
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

    @line_item = double(
      "A line_item",
      id: nil,
      timesheet_id: "timesheet-id",
      available_dates: {
        "Monday, 24 January 2022" => Date.parse("Jan 24 2022"),
        "Tuesday, 25 January 2022" => Date.parse("Jan 25 2022"),
      },
      start_date: nil,
      description: nil,
      start_time: nil,
      end_time: nil,
      hourly_rate: nil,
      to_model: double(
        "to_model",
        model_name: double(
          "model_name",
          name: LineItem,
          route_key: "line_items",
          param_key: "line_item",
          i18n_key: "id",
        ),
        persisted?: false,
      ),
    )
  end

  it "Renders a form for the line item" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    page = Capybara.string(rendered)
    form = page.find("form")
    expect(form["action"]).to eq("/timesheets/timesheet-id/line_items")
  end

  it "renders a start_date field" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    page = Capybara.string(rendered)
    date_select = page.find_field("Start date", type: "select")
    select_options = {}
    date_select.all("option").each do |option|
      select_options[option.text] = option.value
    end

    expect(select_options).to eq(
      {
        "Monday, 24 January 2022" => "2022-01-24",
        "Tuesday, 25 January 2022" => "2022-01-25",
      },
    )
  end

  it "renders a Description field" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    expect(rendered).to have_field("Description", type: "text")
  end

  it "renders a Start Time field" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    expect(rendered).to have_field("Start time", type: "time")
  end

  it "renders an End Time field" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    expect(rendered).to have_field("End time", type: "time")
  end

  it "renders a field for the hourly rate" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    expect(rendered).to have_field("Hourly rate", type: "number")
  end

  it "renders a submit button" do
    render partial: "timesheets/line_items/form", locals: { timesheet: @timesheet, line_item: @line_item }

    expect(rendered).to have_button("Save")
  end
end
