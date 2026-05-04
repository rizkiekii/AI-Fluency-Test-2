require "json"

module RefundBackend
  module Transport
    module Http
      module Middleware
        class ErrorMapping
          def initialize(app)
            @app = app
          end

          def call(env)
            @app.call(env)
          rescue RefundBackend::Domain::Errors::AppError => error
            logger.error(
              event: RefundBackend::Logging::Events::REFUND_PROCESSING_ERROR,
              error_code: error.error_code,
              message: error.message,
              request_id: request_id_for(env)
            )

            render_json(error.status, error.error_code, error.message, request_id_for(env))
          rescue StandardError => error
            logger.error(
              event: RefundBackend::Logging::Events::REFUND_PROCESSING_ERROR,
              error_class: error.class.name,
              message: error.message,
              request_id: request_id_for(env)
            )

            render_json(500, "INTERNAL_SERVER_ERROR", "unexpected server error", request_id_for(env))
          end

          private

          def logger
            Rails.application.config.x.runtime.logger || fallback_logger
          end

          def fallback_logger
            @fallback_logger ||= RefundBackend::Logging::StructuredLogger.new(service_name: "refund-backend-ruby")
          end

          def request_id_for(env)
            env["action_dispatch.request_id"] || "req_unknown"
          end

          def render_json(status, error_code, message, request_id)
            body = JSON.generate(
              error_code: error_code,
              message: message,
              request_id: request_id
            )

            [status, { "Content-Type" => "application/json" }, [body]]
          end
        end
      end
    end
  end
end
