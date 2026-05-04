package logging

const (
	EventRefundRequestReceived  = "refund_request_received"
	EventRefundAuthFailed       = "refund_auth_failed"
	EventRefundValidationFailed = "refund_validation_failed"
	EventRefundPurchaseNotFound = "refund_purchase_not_found"
	EventRefundForbidden        = "refund_forbidden"
	EventRefundPolicyRejected   = "refund_policy_rejected"
	EventRefundProcessed        = "refund_processed"
	EventRefundProcessingError  = "refund_processing_error"
)
