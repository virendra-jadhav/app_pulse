# frozen_string_literal: true

require "csv"
require "app_pulse/writers/base_writer"

module AppPulse
  module Writers
    class CsvWriter < BaseWriter
      def write(data)
        path = daily_file("csv")

        CSV.open(path, "a+") do |csv|
          csv << data.values
        end
      rescue
        # Never crash the app
      end
    end
  end
end
