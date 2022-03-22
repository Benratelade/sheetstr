# frozen_string_literal: true

require "rails_helper"

describe "timesheets/_weekday_form", type: :view do
  before do
    @date = Date.parse("Jan 31 2022")
    timesheet = Timesheet.new

    form_for(timesheet) do |form|
      @form = form
    end

    stub_template("timesheets/_line_item_form.html.erb" => "<div>A line item form</div>")
  end

  it "Renders a section for the day of the week" do
    render partial: "timesheets/weekday_form", locals: { date: @date, form: @form }

    partial = Capybara.string(rendered)
    day_section = partial.find("section.day-section")

    day_title = day_section.find("h3")
    expect(day_title.text).to eq("Monday")
  end

  it "renders the form fields for a Timesheet Line Item" do
    line_items = [
      double("a line item", start_time: double("a start time", wday: 1)), 
      double("another line item", start_time: double("a start time", wday: 1)), 
    ]
    form = double("a form builder")
    fields_for_builder = double("a fields_for form builder")

    allow(form).to receive(:fields_for).with(:line_items) do |_method_name, &block|
      line_items.each do |_line_item|
        fields_for_builder = double("a fields_for form builder", object: _line_item)
        block.call fields_for_builder
      end
    end

    render partial: "timesheets/weekday_form", locals: { date: @date, form: form }

    expect(view).to render_template(partial: "_line_item_form", locals: { form: fields_for_builder })
    expect(view).to render_template(partial: "_line_item_form", locals: { form: fields_for_builder })
  end
end
