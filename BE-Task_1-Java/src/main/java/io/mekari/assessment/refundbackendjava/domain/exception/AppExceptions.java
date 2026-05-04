package io.mekari.assessment.refundbackendjava.domain.exception;

public final class AppExceptions {
    private AppExceptions() {
    }

    public static AppException validation(String message) {
        return new AppException(ErrorCode.VALIDATION_ERROR, 400, message);
    }

    public static AppException unauthorized(String message) {
        return new AppException(ErrorCode.UNAUTHORIZED, 401, message);
    }

    public static AppException forbidden(String message) {
        return new AppException(ErrorCode.FORBIDDEN, 403, message);
    }

    public static AppException notFound(String message) {
        return new AppException(ErrorCode.NOT_FOUND, 404, message);
    }

    public static AppException policyRejected(String message) {
        return new AppException(ErrorCode.POLICY_REJECTED, 422, message);
    }

    public static AppException processing(String message) {
        return new AppException(ErrorCode.PROCESSING_ERROR, 500, message);
    }
}
