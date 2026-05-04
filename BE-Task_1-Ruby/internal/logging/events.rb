module RefundBackend
  module Logging
    module Events
      REFUND_REQUEST_RECEIVED = "refund_request_received"
      REFUND_AUTH_FAILED = "refund_auth_failed"
      REFUND_VALIDATION_FAILED = "refund_validation_failed"
      REFUND_PURCHASE_NOT_FOUND = "refund_purchase_not_found"
      REFUND_FORBIDDEN = "refund_forbidden"
      REFUND_POLICY_REJECTED = "refund_policy_rejected"
      REFUND_PROCESSED = "refund_processed"
      REFUND_PROCESSING_ERROR = "refund_processing_error"
      SERVER_STARTING = "server_starting"
      SERVER_STOPPED = "server_stopped"
    end
  end
end
