# frozen_string_literal: true

require "app_pulse/writers/csv_writer"
require "app_pulse/writers/json_writer"
require "app_pulse/writers/text_writer"

module AppPulse
  module Writers
    def self.fetch(format)
      case format
      when :csv
        CsvWriter.new
      when :json
        JsonWriter.new
      when :text
        TextWriter.new
      else
        CsvWriter.new
      end
    end
  end
end
