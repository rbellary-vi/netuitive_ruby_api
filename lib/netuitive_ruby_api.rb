require 'netuitive/ruby_config_manager'
require 'drb/drb'
require 'netuitive/netuitive_ruby_logger'

class NetuitiveRubyAPI
  class << self
    def setup(server)
      @@netuitivedServer = server
    end

    def netuitivedServer
      @@netuitivedServer
    end

    def send_metrics
      server_interaction { netuitivedServer.sendMetrics }
    end

    def add_sample(metric_id, val)
      server_interaction { netuitivedServer.addSample(metric_id, val) }
    end

    def add_counter_sample(metric_id, val)
      server_interaction { netuitivedServer.addCounterSample(metric_id, val) }
    end

    def aggregate_metric(metric_id, val)
      server_interaction { netuitivedServer.aggregateMetric(metric_id, val) }
    end

    def aggregate_counter_metric(metric_id, val)
      server_interaction { netuitivedServer.aggregateCounterMetric(metric_id, val) }
    end

    def clear_metrics
      server_interaction { netuitivedServer.clearMetrics }
    end

    def interval
      server_interaction { netuitivedServer.interval }
    end

    def event(message, timestamp = Time.new, title = 'Ruby Event', level = 'Info', source = 'Ruby Agent', type = 'INFO', tags = nil)
      server_interaction { netuitivedServer.event(message, timestamp, title, level, source, type, tags) }
    end

    def exception_event(exception, klass = nill, uri = nil, controller = nil, action = nil)
      server_interaction { netuitivedServer.exceptionEvent(exception, klass, uri, controller, action) }
    end

    def stop_server
      server_interaction { netuitivedServer.stopServer }
    end

    def server_interaction
      Thread.new do
        begin
          yield
        rescue => e
          NetuitiveLogger.log.error "unable to connect to netuitived: message:#{e.message} backtrace:#{e.backtrace}"
        end
      end
    end
  end
end

ConfigManager.setup
SERVER_URI = "druby://#{ConfigManager.netuitivedAddr}:#{ConfigManager.netuitivedPort}".freeze
DRb.start_service
NetuitiveRubyAPI.setup(DRbObject.new_with_uri(SERVER_URI))
