package middleware

import (
	"encoding/json"
	stderrors "errors"
	"net/http"

	domainerrors "gotest/internal/domain/errors"
)

func WriteJSON(w http.ResponseWriter, statusCode int, payload any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	_ = json.NewEncoder(w).Encode(payload)
}

func WriteAppError(w http.ResponseWriter, err error) {
	var appError *domainerrors.AppError
	if stderrors.As(err, &appError) {
		WriteJSON(w, appError.Status, map[string]string{
			"error": appError.Message,
			"code":  string(appError.Code),
		})
		return
	}

	WriteJSON(w, http.StatusInternalServerError, map[string]string{
		"error": "internal server error",
		"code":  string(domainerrors.CodeProcessing),
	})
}
