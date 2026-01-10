# frozen_string_literal: true

require "time"

module AppPulse
  module Utils
    module Time
      class << self
        # Returns current UTC time in ISO 8601 format
        # Example: "2026-01-10T14:23:45Z"
        def now_iso
          ::Time.now.utc.iso8601
        end
      end
    end
  end
end
