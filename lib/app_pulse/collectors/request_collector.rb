# frozen_string_literal: true

require "app_pulse/utils/time"
require "app_pulse/writers"

module AppPulse
  module Collector
    class RequestCollector
      class << self
        def collect(env:, status:, duration:, error: nil)
          return unless sample?

          data = build_payload(env, status, duration, error)
          writer.write(data)
        rescue
          # Never break the host application
        end

        private

        def build_payload(env, status, duration, error)
          {
            timestamp: Utils::Time.now_iso,
            method: env["REQUEST_METHOD"],
            path: env["PATH_INFO"],
            status: status,
            duration_ms: duration,
            success: status < 500,
            error: error ? error.message : nil
          }
        end

        def writer
          Writers.fetch(AppPulse.config.output_format)
        end

        def sample?
          rand <= AppPulse.config.sampling_rate
        end
      end
    end
  end
end
