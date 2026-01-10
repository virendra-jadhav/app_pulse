# frozen_string_literal: true

require "app_pulse/writers/base_writer"

module AppPulse
  module Writers
    class TextWriter < BaseWriter
      def write(data)
        path = daily_file("txt")

        File.open(path, "a+") do |file|
          file.puts(data.map { |k, v| "#{k}=#{v}" }.join(" | "))
        end
      rescue
        # Never crash the app
      end
    end
  end
end
