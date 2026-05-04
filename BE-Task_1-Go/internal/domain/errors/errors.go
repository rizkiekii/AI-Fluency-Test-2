package errors

import "fmt"

type Code string

const (
	CodeValidation     Code = "validation_failed"
	CodeUnauthorized   Code = "unauthorized"
	CodeForbidden      Code = "forbidden"
	CodeNotFound       Code = "not_found"
	CodePolicyRejected Code = "policy_rejected"
	CodeProcessing     Code = "processing_error"
)

type AppError struct {
	Code    Code
	Message string
	Status  int
}

func (e *AppError) Error() string {
	return fmt.Sprintf("%s: %s", e.Code, e.Message)
}

func NewValidation(message string) *AppError {
	return &AppError{Code: CodeValidation, Message: message, Status: 400}
}

func NewUnauthorized(message string) *AppError {
	return &AppError{Code: CodeUnauthorized, Message: message, Status: 401}
}

func NewForbidden(message string) *AppError {
	return &AppError{Code: CodeForbidden, Message: message, Status: 403}
}

func NewNotFound(message string) *AppError {
	return &AppError{Code: CodeNotFound, Message: message, Status: 404}
}

func NewPolicyRejected(message string) *AppError {
	return &AppError{Code: CodePolicyRejected, Message: message, Status: 422}
}

func NewProcessing(message string) *AppError {
	return &AppError{Code: CodeProcessing, Message: message, Status: 500}
}
