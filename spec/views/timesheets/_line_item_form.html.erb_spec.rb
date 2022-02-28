require "rails_helper"

describe "timesheets/_line_item_form", type: :view do
  before do
    @date = Date.parse("Jan 31 2022")
    
    form_for(timesheet) do |form|
      @form = form
    end
  end

  it "renders a Start Time field" do
    render partial: "timesheets/line_item_form", locals: { date: @date, form: @form }

    expect(rendered).to have_field("Start Time")
  end

  # it "renders an End Time field" do
  #   pending
  # end
end