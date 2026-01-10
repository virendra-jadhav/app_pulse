# frozen_string_literal: true

require "app_pulse/collectors/request_collector"

module AppPulse
  module Middleware
    class Request
      def initialize(app)
        @app = app
      end

      def call(env)
        return @app.call(env) unless AppPulse.config.enabled

        start_time = monotonic_time

        status, headers, response = @app.call(env)

        duration = elapsed_ms(start_time)

        Collector::RequestCollector.collect(
          env: env,
          status: status,
          duration: duration
        )

        [status, headers, response]
      rescue => error
        Collector::RequestCollector.collect(
          env: env,
          status: 500,
          duration: elapsed_ms(start_time),
          error: error
        )
        raise
      end

      private

      # def monotonic_time
      #   Process.clock_gettime(Process::CLOCK_MONOTONIC)
      # end
      def monotonic_time
        if Process.const_defined?(:CLOCK_MONOTONIC)
          Process.clock_gettime(Process::CLOCK_MONOTONIC)
        else
          Time.now.to_f
        end
      end


      def elapsed_ms(start_time)
        ((monotonic_time - start_time) * 1000).round(2)
      end
    end
  end
end
