# frozen_string_literal: true

module Utils
  module DateTimeBuilder
    def self.build_from_date_and_time(date:, time:, timezone_identifier:)
      raise "Missing date" if date.blank?
      raise "Missing time" if time.blank?
      raise "Missing timezone identifier" if timezone_identifier.blank?

      Time.find_zone(timezone_identifier).parse("#{date} #{time}")
    end
  end
end
