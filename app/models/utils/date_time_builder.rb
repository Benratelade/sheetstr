# frozen_string_literal: true

module Utils
  module DateTimeBuilder
    def self.build_from_date_and_time(date:, time:)
      raise "Missing date" if date.blank?
      raise "Missing time" if time.blank?

      Time.zone.parse("#{date} #{time}")
    end
  end
end
