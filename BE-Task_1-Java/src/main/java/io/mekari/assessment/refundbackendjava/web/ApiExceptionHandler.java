package io.mekari.assessment.refundbackendjava.web;

import io.mekari.assessment.refundbackendjava.domain.exception.AppException;
import io.mekari.assessment.refundbackendjava.domain.exception.AppExceptions;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {
    @ExceptionHandler(AppException.class)
    public ResponseEntity<ErrorResponse> handleAppException(AppException exception) {
        return ResponseEntity.status(exception.getStatus()).body(
            new ErrorResponse(
                exception.getCode().name(),
                exception.getMessage(),
                RequestContextHolder.getRequestId()
            )
        );
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleUnreadableBody(HttpMessageNotReadableException exception) {
        AppException appException = AppExceptions.validation("request body is invalid");
        return ResponseEntity.status(appException.getStatus()).body(
            new ErrorResponse(
                appException.getCode().name(),
                appException.getMessage(),
                RequestContextHolder.getRequestId()
            )
        );
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception exception) {
        AppException appException = AppExceptions.processing("internal server error");
        return ResponseEntity.status(appException.getStatus()).body(
            new ErrorResponse(
                appException.getCode().name(),
                appException.getMessage(),
                RequestContextHolder.getRequestId()
            )
        );
    }
}
