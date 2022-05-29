# frozen_string_literal: true

require "rails_helper"

describe "timesheets/_form", type: :view do
  before do
    @timesheet = Timesheet.new(
      start_date: Date.parse("Jan 31 2022"),
      end_date: Date.parse("Feb 06 2022"),
    )
    stub_template("timesheets/_weekday_form.html.erb" => "<section>A Weekeday section</section>")
  end

  it "Renders a form for the Timesheet" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_css("form")
  end

  it "displays the start and end dates" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_field("timesheet_start_date", with: "2022-01-31")
    expect(rendered).to have_field("timesheet_end_date", with: "2022-02-06")
  end

  it "displays a timesheets/_weekday_form partial for each day in that period" do
    form_builder = double(
      "A form builder",
      label: "A label",
      date_field: "A date field",
      submit: "A submit tag",
    )
    allow(view).to receive(:form_for) do |&block|
      block.call(form_builder)
    end

    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(view).to render_template(partial: "_weekday_form", count: 7)
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date,
      },
    )
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date + 1,
      },
    )
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date + 2,
      },
    )
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date + 3,
      },
    )
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date + 4,
      },
    )
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date + 5,
      },
    )
    expect(view).to render_template(
      partial: "_weekday_form",
      locals: {
        form: form_builder,
        date: @timesheet.start_date + 6,
      },
    )
  end

  it "displays a submit button" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_button("Submit")
  end
end
