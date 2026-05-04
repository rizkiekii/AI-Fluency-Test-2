require "securerandom"

module RefundBackend
  module Transport
    module Http
      module Middleware
        class RequestContext
          REQUEST_ID_HEADER = "HTTP_X_REQUEST_ID"
          TRACE_ID_HEADER = "HTTP_X_TRACE_ID"

          def initialize(app)
            @app = app
          end

          def call(env)
            request_id = env[REQUEST_ID_HEADER].presence || default_request_id
            trace_id = env[TRACE_ID_HEADER].presence

            env["action_dispatch.request_id"] = request_id
            env["refund_backend.request_context"] = {
              request_id: request_id,
              trace_id: trace_id
            }

            status, headers, response = @app.call(env)
            headers["X-Request-Id"] = request_id
            headers["X-Trace-Id"] = trace_id if trace_id

            [status, headers, response]
          end

          private

          def default_request_id
            "req_#{SecureRandom.hex(10)}"
          end
        end
      end
    end
  end
end
