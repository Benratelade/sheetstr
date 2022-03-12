require 'rails_helper'

describe "timesheets/show", type: :view do
  before do
    @current_user = double("the user", email: "ratelade.benjamin@gmail.com")
    allow(controller).to receive(:current_user).and_return(@current_user)
  end

  it "Displays the email of the current user" do
    @timesheet = double(
      "A Timesheet", 
      start_date: Date.parse("24 Jan 2022"), 
      end_date: Date.parse("30 Jan 2022"),
      total_hours_worked: "",
    )
    render

    expect(rendered).to have_css("h2", text: "Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")
  end

  it "Displays the total number of hours worked for that timesheet" do
    line_items = [
      double(
        "line item 1", 
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:00"),
      ), 
      double(
        "line item 2", 
        start_time: Time.zone.parse("Feb 01 2022 08:00am"),
        end_time: Time.zone.parse("Feb 01 2022 17:00"),
      ), 
      double(
        "line item 3", 
        start_time: Time.zone.parse("Feb 02 2022 08:00am"),
        end_time: Time.zone.parse("Feb 02 2022 17:00"),
      )
    ]

    @timesheet = double(
      start_date: Date.parse("24 Jan 2022"), 
      end_date: Date.parse("30 Jan 2022"),
      line_items: line_items, 
      total_hours_worked: "27",
    )

    render

    page = Capybara.string(rendered)
    total = page.find("#total-section #value")
    expect(total.text).to eq("27")

  end
end