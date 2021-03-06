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
      total_decimal_hours: "total decimal hours",
      subtotal: "subtotal",
      weekday: "monday",
      timesheet_id: "timesheet-id",
    )
    @component = LineItems::LineItemSummaryComponent.new(@item)
  end

  it "renders things within a .line-item div" do
    render_inline(@component)

    expect(page).to have_css("li.line-item.d-flex.list-group-item.justify-content-between.align-items-start")
  end

  it "displays the description as a header" do
    render_inline(@component)

    expect(list_info).to have_css("h4")
    expect(list_info).to have_css(" h4 .description", text: "description")
  end

  it "displays information on the line item" do
    render_inline(@component)

    expect(list_info).to have_css(".hourly-rate", text: "24")
    expect(list_info).to have_css(".total-decimal-hours", text: "total decimal hours")
    expect(list_info).to have_css(".subtotal", text: "subtotal")
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

  it "shows decimal hours and subtotal with 2 digits after the decimal place" do
    allow(@item).to receive(:subtotal).and_return(BigDecimal("116.3333333333"))
    allow(@item).to receive(:total_decimal_hours).and_return(BigDecimal("4.3333333333"))

    render_inline(@component)

    expect(list_info).to have_css(".total-decimal-hours", text: "4.33")
    expect(list_info).to have_css(".subtotal", text: "116.33")
  end
end
