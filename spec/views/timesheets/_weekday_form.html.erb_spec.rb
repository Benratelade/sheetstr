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
    line_items = [double("a line item"), double("another line item")]
    form = double("a form builder")
    fields_for_builder = double("a fields_for form builder")
    line_items_form = double("a new form")
    
    allow(form).to receive(:fields_for).with(:line_items) do |method_name, &block|
      line_items.each do |line_item|
        block.call fields_for_builder
      end
    end

    render partial: "timesheets/weekday_form", locals: { date: @date, form: form }
    
    expect(view).to render_template(partial: "_line_item_form", locals: { form: fields_for_builder })
    expect(view).to render_template(partial: "_line_item_form", locals: { form: fields_for_builder })
  end
end