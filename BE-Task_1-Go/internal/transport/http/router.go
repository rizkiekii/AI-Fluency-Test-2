package http

import (
	stdhttp "net/http"

	"gotest/internal/logging"
	"gotest/internal/repository/interfaces"
	"gotest/internal/transport/http/middleware"
)

type Dependencies struct {
	Logger             logging.EventLogger
	AgentRepository    interfaces.AgentRepository
	PurchaseRepository interfaces.PurchaseRepository
	RefundRepository   interfaces.RefundRepository
}

type Handler struct {
	dependencies Dependencies
}

func NewRouter(dependencies Dependencies) stdhttp.Handler {
	handler := &Handler{dependencies: dependencies}

	mux := stdhttp.NewServeMux()
	mux.HandleFunc("GET /healthz", handler.handleHealth)

	return middleware.RequestContext(mux)
}

func (handler *Handler) handleHealth(w stdhttp.ResponseWriter, _ *stdhttp.Request) {
	middleware.WriteJSON(w, stdhttp.StatusOK, map[string]string{"status": "ok"})
}
