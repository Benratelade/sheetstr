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
    )
    render

    expect(rendered).to have_css("h2", text: "Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")
  end

  it "Displays "
end