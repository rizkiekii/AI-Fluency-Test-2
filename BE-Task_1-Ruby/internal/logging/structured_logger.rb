require "json"
require "time"

module RefundBackend
  module Logging
    class StructuredLogger
      SENSITIVE_KEYS = %w[authorization override_token].freeze

      def initialize(stdout: $stdout, stderr: $stderr, service_name:)
        @stdout = stdout
        @stderr = stderr
        @service_name = service_name
        @mutex = Mutex.new
      end

      def info(event:, **payload)
        write(@stdout, severity: "INFO", event: event, payload: payload)
      end

      def error(event:, **payload)
        write(@stderr, severity: "ERROR", event: event, payload: payload)
      end

      private

      def write(io, severity:, event:, payload:)
        record = {
          timestamp: Time.now.utc.iso8601(6),
          severity: severity,
          service: @service_name,
          event: event
        }.merge(sanitize(payload))

        @mutex.synchronize do
          io.puts(JSON.generate(record))
          io.flush
        end
      end

      def sanitize(value)
        case value
        when Array
          value.map { |item| sanitize(item) }
        when Hash
          value.each_with_object({}) do |(key, nested_value), result|
            normalized_key = key.to_s
            result[key] = if SENSITIVE_KEYS.include?(normalized_key)
                            "[FILTERED]"
                          else
                            sanitize(nested_value)
                          end
          end
        else
          value
        end
      end
    end
  end
end