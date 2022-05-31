# frozen_string_literal: true

require "rails_helper"

describe "timesheets/_line_item_form", type: :view do
  before do
    @date = Date.parse("Jan 31 2022")
    line_item = LineItem.new
    fields_for(line_item) do |form|
      @form = form
    end
  end

  it "renders a Description field" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("Description", type: "text")
  end

  it "renders a Start Time field" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("Start time", type: "time")
  end

  it "renders an End Time field" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("End time", type: "time")
  end

  it "renders a field for the hourly rate" do
    render partial: "timesheets/line_item_form", locals: { form: @form }

    expect(rendered).to have_field("Hourly rate", type: "number")
  end
end
