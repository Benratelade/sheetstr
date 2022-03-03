require "rails_helper"

describe "timesheets/_line_item_form", type: :view do
  before do
    @date = Date.parse("Jan 31 2022")
    line_item = TimesheetLineItem.new
    fields_for(line_item) do |form|
      @form = form
    end
  end

  it "renders a Description field" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("Description")
  end

  it "renders a Start Time field" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("Start Time")
  end

  it "renders an End Time field" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("End Time")
  end

  it "renders a field for the hourly rate" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("Hourly Rate")
  end
end