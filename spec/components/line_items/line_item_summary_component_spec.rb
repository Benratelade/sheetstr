# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineItems::LineItemSummaryComponent, type: :component do
  def list_container
    page.find(".line-item")
  end

  before do
    @item = double(
      "line item ",
      description: "description",
      hourly_rate: 24,
      total_decimal_hours: "total decimal hours",
      subtotal: "subtotal",
      weekday: "monday",
    )
    @component = LineItems::LineItemSummaryComponent.new(@item)
  end

  it "renders things within a .line-item div" do
    render_inline(@component)

    expect(page).to have_css("li.list-group-item.line-item")
    # d-flex justify-content-between align-items-start
  end

  it "displays the description as a header" do
    render_inline(@component)

    expect(list_container).to have_css("h4")
    expect(list_container).to have_css("h4 .description", text: "description")
  end

  it "displays information on the line item" do
    render_inline(@component)

    expect(list_container).to have_css(".hourly-rate", text: "24")
    expect(list_container).to have_css(".total-decimal-hours", text: "total decimal hours")
    expect(list_container).to have_css(".subtotal", text: "subtotal")
  end

  it "shows decimal hours and subtotal with 2 digits after the decimal place" do
    allow(@item).to receive(:subtotal).and_return(BigDecimal("116.3333333333"))
    allow(@item).to receive(:total_decimal_hours).and_return(BigDecimal("4.3333333333"))

    render_inline(@component)

    expect(list_container).to have_css(".total-decimal-hours", text: "4.33")
    expect(list_container).to have_css(".subtotal", text: "116.33")
  end
end
