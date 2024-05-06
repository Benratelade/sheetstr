# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineItems::LineItemSummaryComponent, type: :component do
  def list_container
    page.find(".line-item")
  end

  def list_info
    list_container.find(".line-item-info")
  end

  before do
    @item = double(
      "line item ",
      id: "line-item-id",
      description: "description",
      hourly_rate: 24,
      total_decimal_hours: BigDecimal("4.3333333333333"),
      hours_breakdown: { hours: "x", minutes: "y" },
      subtotal: "subtotal",
      timesheet_id: "timesheet-id",
      start_time: "start time",
    )
    @component = LineItems::LineItemSummaryComponent.new(item: @item, timezone_identifier: "timezone identifier")
    allow(Utils::DateTimeFormatter).to receive(:format_date_in_timezone).and_return("localised start time")
    allow(@component).to receive(:render).and_call_original
    @description_list = double("a description list")
    allow(Utilities::DescriptionListComponent).to receive(:new).and_return(@description_list)
    allow(@component).to receive(:render).with(@description_list) { "a description list component" }
  end

  it "renders things within a .line-item div" do
    render_inline(@component)

    expect(page).to have_css("li.line-item.d-flex.list-group-item.justify-content-between.align-items-start")
  end

  it "renders a DescriptionList component for the line item" do
    expect(Utils::DateTimeFormatter).to(
      receive(:format_date_in_timezone).with(
        date: "start time",
        timezone_identifier: "timezone identifier",
      ),
    )
    expect(Utilities::DescriptionListComponent).to receive(:new).with(
      {
        "Description" => "description",
        "Hourly Rate" => 24,
        "Duration (hours)" => "x hours y minutes",
        "Duration (decimal)" => "4.33",
        "Subtotal" => "subtotal",
        "Date" => "localised start time",
      },
    )

    render_inline(@component)

    expect(list_info).to have_content("a description list component")
  end

  it "renders a button to edit the line item" do
    button_component = double("a button component")
    expect(Utilities::Buttons::ButtonComponent).to receive(:new).with(
      text: "Edit",
      link: "http://test.host/timesheets/timesheet-id/line_items/line-item-id/edit",
      style: "primary",
    ).and_return(button_component)
    expect(@component).to receive(:render).with(button_component) { "A rendered button component" }

    render_inline(@component)

    expect(list_container).to have_content("A rendered button component")
  end
end
