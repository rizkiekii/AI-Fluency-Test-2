package io.mekari.assessment.refundbackendjava.domain.exception;

public class AppException extends RuntimeException {
    private final ErrorCode code;
    private final int status;

    public AppException(ErrorCode code, int status, String message) {
        super(message);
        this.code = code;
        this.status = status;
    }

    public ErrorCode getCode() {
        return code;
    }

    public int getStatus() {
        return status;
    }
}
