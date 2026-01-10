# frozen_string_literal: true

require "app_pulse/version"
require "app_pulse/config"
require "app_pulse/middleware/request"

module AppPulse
  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end
  end
end
