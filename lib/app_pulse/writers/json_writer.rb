# frozen_string_literal: true

require "json"
require "app_pulse/writers/base_writer"

module AppPulse
  module Writers
    class JsonWriter < BaseWriter
      def write(data)
        path = daily_file("json")

        File.open(path, "a+") do |file|
          file.puts(JSON.generate(data))
        end
      rescue
        # Never crash the app
      end
    end
  end
end
