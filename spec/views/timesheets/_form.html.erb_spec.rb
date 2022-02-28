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

  it "displays the start and end dates in disabled fields" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(rendered).to have_field("timesheet_start_date", disabled: true, with: "2022-01-31")
    expect(rendered).to have_field("timesheet_end_date", disabled: true, with: "2022-02-06")
  end

  it "displays a timesheets/_weekday_form partial for each day in that period" do
    render partial: "timesheets/form", locals: { timesheet: @timesheet }

    expect(view).to render_template(partial: "_weekday_form", count: 7)
  end
end
