package io.mekari.assessment.refundbackendjava.logging;

public final class Events {
    public static final String REFUND_REQUEST_RECEIVED = "refund_request_received";
    public static final String REFUND_AUTH_FAILED = "refund_auth_failed";
    public static final String REFUND_VALIDATION_FAILED = "refund_validation_failed";
    public static final String REFUND_PURCHASE_NOT_FOUND = "refund_purchase_not_found";
    public static final String REFUND_FORBIDDEN = "refund_forbidden";
    public static final String REFUND_POLICY_REJECTED = "refund_policy_rejected";
    public static final String REFUND_PROCESSED = "refund_processed";
    public static final String REFUND_PROCESSING_ERROR = "refund_processing_error";

    private Events() {
    }
}
