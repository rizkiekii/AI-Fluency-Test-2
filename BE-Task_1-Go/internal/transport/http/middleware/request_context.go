package middleware

import (
	"crypto/rand"
	"encoding/hex"
	"net/http"
	"strings"

	"gotest/internal/logging"
)

func RequestContext(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requestID := strings.TrimSpace(r.Header.Get("X-Request-ID"))
		if requestID == "" {
			requestID = newRequestID()
		}

		traceID := strings.TrimSpace(r.Header.Get("X-Trace-ID"))
		ctx := logging.WithRequestContext(r.Context(), requestID, traceID)

		w.Header().Set("X-Request-ID", requestID)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func newRequestID() string {
	buffer := make([]byte, 16)
	if _, err := rand.Read(buffer); err != nil {
		return "request-id-unavailable"
	}

	return hex.EncodeToString(buffer)
}
