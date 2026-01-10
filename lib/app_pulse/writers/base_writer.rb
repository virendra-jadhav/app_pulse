# frozen_string_literal: true

require "fileutils"
require "date"

module AppPulse
  module Writers
    class BaseWriter
      def write(_data)
        raise NotImplementedError
      end

      protected

      def output_dir
        AppPulse.config.output_path
      end

      def daily_file(extension)
        FileUtils.mkdir_p(output_dir)

        date = Date.today.strftime("%Y-%m-%d")
        File.join(output_dir, "#{date}.#{extension}")
      end
    end
  end
end
