# frozen_string_literal: true

module Utils
  module DateTimeFormatter
    def self.format_date(date)
      return "" if date.blank?

      date.strftime("%A, %d %b %Y")
    end
  end
end
