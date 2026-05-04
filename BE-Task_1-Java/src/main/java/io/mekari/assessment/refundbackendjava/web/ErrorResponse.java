package io.mekari.assessment.refundbackendjava.web;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ErrorResponse {
    @JsonProperty("error_code")
    private final String errorCode;
    private final String message;
    @JsonProperty("request_id")
    private final String requestId;

    public ErrorResponse(String errorCode, String message, String requestId) {
        this.errorCode = errorCode;
        this.message = message;
        this.requestId = requestId;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public String getMessage() {
        return message;
    }

    public String getRequestId() {
        return requestId;
    }
}
