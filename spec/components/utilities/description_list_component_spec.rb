# frozen_string_literal: true

require "rails_helper"

RSpec.describe Utilities::DescriptionListComponent, type: :component do
  before do
    @component = Utilities::DescriptionListComponent.new(
      {
        "key 1" => "value 1",
        "key 2" => "value 2",
      },
    )
  end

  it "renders a description list" do
    render_inline(@component)

    expect(page).to have_css("dl")
  end

  it "renders one dt element for each key in the provided hash" do
    render_inline(@component)

    expect(page.find_all("dl dt").map(&:text)).to eq(["key 1", "key 2"])
  end

  it "renders one dd element for each value in the provided hash" do
    render_inline(@component)

    expect(page.find_all("dl dd").map(&:text)).to eq(["value 1", "value 2"])
  end

  it "correctly links a dd element to its dt counterpart" do
    render_inline(@component)

    expect(page).to have_css("dl dt[name='key 1']")
    expect(page).to have_css("dl dd[for='key 1']")
  end
end
