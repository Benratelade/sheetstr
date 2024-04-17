# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timesheets::TimesheetSummaryComponent, type: :component do
  before do
    @timesheet = double(
      "A Timesheet",
      formatted_total_decimal_hours: 3.4,
      hours_breakdown: {
        hours: 26,
        minutes: 47,
      },
      formatted_total_revenue: "$888",
    )

    @description_list = double("a description list")
    allow(Utilities::DescriptionListComponent).to receive(:new).and_return(@description_list)
    @component = Timesheets::TimesheetSummaryComponent.new(timesheet: @timesheet)
    allow(@component).to receive(:render).with(@description_list) { "a description list" }
  end

  it "renders a description list" do
    expect(Utilities::DescriptionListComponent).to(
      receive(:new).with(
        {
          "Total hours worked (decimal)" => 3.4,
          "Duration (in hours)" => "26 hours 47 minutes",
          "Total revenue" => "$888",
        },
      ),
    )
    expect(@component).to receive(:render).with(@description_list)

    render_inline(@component)

    expect(page).to have_content("a description list")
  end
end
