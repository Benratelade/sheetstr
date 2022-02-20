require 'rails_helper'

describe "timesheets/new", type: :view do
  before do
    @current_user = double("the user", email: "ratelade.benjamin@gmail.com")
    allow(controller).to receive(:current_user).and_return(@current_user)
  end

  it "Displays the email of the current user" do
    render

    expect(rendered).to have_css("h2", text: "Welcome ratelade.benjamin@gmail.com")
  end

  it "Displays a title for the New Timesheet" do 
    render

    expect(rendered).to have_css("h3", text: "New Timesheet")
  end
end