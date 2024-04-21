# frozen_string_literal: true

require "rails_helper"

describe "timesheets/show", type: :view do
  before do
    @current_user = double("the user", email: "ratelade.benjamin@gmail.com")
    allow(controller).to receive(:current_user).and_return(@current_user)

    @timesheet = double(
      "A Timesheet",
      id: "timesheet-id",
      start_date: Date.parse("24 Jan 2022"),
      end_date: Date.parse("30 Jan 2022"),
      daily_line_items: [],
      grouped_line_items: [],
    )

    button_component = double("a button component")
    allow(view).to receive(:render).and_call_original
    allow(Utilities::Buttons::ButtonComponent).to receive(:new).and_return(button_component)
    allow(view).to receive(:render).with(button_component) { "some rendered button component" }
    @timesheet_summary_component = double("timesheet summary component")
    allow(Timesheets::TimesheetSummaryComponent).to receive(:new).and_return(@timesheet_summary_component)
    allow(view).to receive(:render).with(@timesheet_summary_component) { "rendered timesheet summary component" }
    @daily_breakdown_component = double("timesheet breakdown component")
    allow(Timesheets::DailyBreakdownComponent).to receive(:new).and_return(@daily_breakdown_component)
    allow(view).to receive(:render).with(@daily_breakdown_component) { "rendered daily breakdown component" }
  end

  it "Displays the date for the timesheet" do
    render

    expect(rendered).to have_css(
      "h2#page-header",
      text: "Timesheet for Monday, January 24 2022 to Sunday, January 30 2022",
    )
  end

  it "renders a TimesheetSummaryComponent" do
    expect(Timesheets::TimesheetSummaryComponent).to(
      receive(:new).with(timesheet: @timesheet),
    )
    expect(view).to receive(:render).with(@timesheet_summary_component)

    render

    expect(rendered).to have_content("rendered timesheet summary component")
  end

  it "displays a summary section" do
    render

    expect(rendered).to have_css("section.mb-2.col-6#summary-section")
  end

  it "Renders a TimesheetLineItemsSummaryComponent" do
    summary_component = double("A timesheet line items summary component")
    expect(Timesheets::TimesheetLineItemsSummaryComponent).to receive(:new).with(
      timesheet: @timesheet,
    ).and_return(summary_component)
    expect(view).to receive(:render).with(summary_component) { "summary component rendered" }

    render

    page = Capybara.string(rendered)
    summary_section = page.find("#summary-section")
    expect(summary_section).to have_content("summary component rendered")
  end

  it "Displays a section for actions" do
    render

    page = Capybara.string(rendered)
    expect(page).to have_css("section.mb-2.page-actions")
  end

  it "Displays a button to add more items" do
    add_item_button = double("add item button")

    expect(Utilities::Buttons::ButtonComponent).to receive(:new).with(
      text: "Add item",
      link: "/timesheets/timesheet-id/line_items/new",
      style: "primary",
    ).and_return(add_item_button)
    expect(view).to receive(:render).with(add_item_button) { "A rendered add item button component" }

    render

    page = Capybara.string(rendered)
    actions_section = page.find("section.mb-2.page-actions")
    expect(actions_section).to have_content("A rendered add item button component")
  end

  it "Displays a link to go to the list of all timesheets" do
    view_timesheets_button = double("view timesheets button")

    expect(Utilities::Buttons::ButtonComponent).to receive(:new).with(
      text: "View my timesheets",
      link: "/timesheets",
      style: "secondary",
    ).and_return(view_timesheets_button)
    expect(view).to receive(:render).with(view_timesheets_button) { "A rendered view timesheets button component" }

    render

    page = Capybara.string(rendered)
    actions_section = page.find("section.mb-2.page-actions")
    expect(actions_section).to have_content("A rendered view timesheets button component")
  end

  it "Displays a daily breakdown component" do
    expect(Timesheets::DailyBreakdownComponent).to receive(:new).with(
      timesheet: @timesheet,
    ).and_return(@daily_breakdown_component)

    render

    expect(rendered).to have_content("rendered daily breakdown component")
  end

  it "displays a delete button" do
    delete_timesheet_button = double("delete timesheet button")

    expect(Utilities::Buttons::ButtonComponent).to receive(:new).with(
      text: "Delete",
      link: "/timesheets/timesheet-id",
      style: "danger",
      method: "delete",
    ).and_return(delete_timesheet_button)
    expect(view).to receive(:render).with(delete_timesheet_button) { "A rendered delete timesheet button component" }

    render

    page = Capybara.string(rendered)
    expect(page).to have_content("A rendered delete timesheet button component")
  end
end
