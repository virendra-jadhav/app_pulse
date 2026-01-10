module AppPulse
  class Config 
    attr_accessor :enabled,
                  :output_format,
                  :output_path,
                  :slow_threshold_ms,
                  :sampling_rate

    def initialize
      @enabled = true
      @output_format = :csv
      @output_path = "log/app_pulse"
      @slow_threshold_ms = nil
      @sampling_rate = 1.0
    end
  end
end