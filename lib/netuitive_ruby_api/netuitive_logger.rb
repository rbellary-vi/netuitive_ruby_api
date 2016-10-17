require 'logger'
module NetuitiveRubyApi
  class CheaterLogger
    attr_accessor :level
    def debug(message)
    end

    def error(message)
    end

    def info(message)
    end
  end

  class NetuitiveLogger
    class << self
      attr_reader :log
      def setup
        file = NetuitiveRubyApi::ConfigManager.property('logLocation', 'NETUITIVE_RUBY_LOG_LOCATION', "#{File.expand_path('../../..', __FILE__)}/log/netuitive.log")
        age = NetuitiveRubyApi::ConfigManager.property('logAge', 'NETUITIVE_RUBY_LOG_AGE', 'daily')
        size = NetuitiveRubyApi::ConfigManager.property('logSize', 'NETUITIVE_RUBY_LOG_SIZE', nil)
        @log = Logger.new(file, age, size)
      rescue
        puts 'netuitive unable to open log file'
        @log = NetuitiveRubyApi::CheaterLogger.new
      end
    end
  end
end
