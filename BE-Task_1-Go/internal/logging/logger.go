package logging

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"strings"
	"time"
)

type EventLogger interface {
	Info(ctx context.Context, event string, fields map[string]any)
	Error(ctx context.Context, event string, fields map[string]any)
}

type JSONLogger struct {
	serviceName string
	stdout      *log.Logger
	stderr      *log.Logger
}

type requestContextKey struct{}

type RequestContext struct {
	RequestID string
	TraceID   string
}

func NewJSONLogger(serviceName string, stdout io.Writer, stderr io.Writer) *JSONLogger {
	return &JSONLogger{
		serviceName: serviceName,
		stdout:      log.New(stdout, "", 0),
		stderr:      log.New(stderr, "", 0),
	}
}

func WithRequestContext(ctx context.Context, requestID string, traceID string) context.Context {
	return context.WithValue(ctx, requestContextKey{}, RequestContext{RequestID: requestID, TraceID: traceID})
}

func (logger *JSONLogger) Info(ctx context.Context, event string, fields map[string]any) {
	logger.write(ctx, logger.stdout, "info", event, fields)
}

func (logger *JSONLogger) Error(ctx context.Context, event string, fields map[string]any) {
	logger.write(ctx, logger.stderr, "error", event, fields)
}

func (logger *JSONLogger) write(ctx context.Context, destination *log.Logger, level string, event string, fields map[string]any) {
	record := map[string]any{
		"timestamp": time.Now().UTC().Format(time.RFC3339Nano),
		"level":     level,
		"service":   logger.serviceName,
		"event":     event,
	}

	if requestContext, ok := ctx.Value(requestContextKey{}).(RequestContext); ok {
		if requestContext.RequestID != "" {
			record["request_id"] = requestContext.RequestID
		}
		if requestContext.TraceID != "" {
			record["trace_id"] = requestContext.TraceID
		}
	}

	for key, value := range fields {
		if isSensitiveField(key) {
			continue
		}
		record[key] = value
	}

	payload, err := json.Marshal(record)
	if err != nil {
		destination.Printf(`{"timestamp":"%s","level":"error","service":"%s","event":"logger_encoding_failed","error":%q}`,
			time.Now().UTC().Format(time.RFC3339Nano),
			logger.serviceName,
			fmt.Sprintf("%v", err),
		)
		return
	}

	destination.Println(string(payload))
}

func isSensitiveField(key string) bool {
	switch strings.ToLower(key) {
	case "authorization", "override_token":
		return true
	default:
		return false
	}
}
