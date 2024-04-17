# frozen_string_literal: true

LineItem.all.each do |li|
  li.update!(hourly_rate_cents: Money.from_amount(li.hourly_rate, "AUD").cents)
end
