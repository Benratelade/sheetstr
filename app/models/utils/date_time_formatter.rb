# frozen_string_literal: true

module Utils
  module DateTimeFormatter
    def self.format_date(date)
      return "" if date.blank?

      date.strftime("%A, %d %b %Y")
    end

    def self.format_date_in_timezone(date: , timezone_identifier: )
      date.in_time_zone(timezone_identifier).strftime("%A, %d %B %Y")
    end
  end
end
