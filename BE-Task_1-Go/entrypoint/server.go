package entrypoint

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"gotest/config"
	"gotest/internal/logging"
	"gotest/internal/repository/interfaces"
	"gotest/internal/repository/memory"
	transporthttp "gotest/internal/transport/http"
)

func Run() error {
	appConfig := config.Load()
	logger := logging.NewJSONLogger(appConfig.ServiceName, os.Stdout, os.Stderr)

	store := memory.NewStore()
	memory.Seed(store, time.Now().UTC())

	dependencies := transporthttp.Dependencies{
		Logger:             logger,
		AgentRepository:    memory.NewAgentRepository(store),
		PurchaseRepository: memory.NewPurchaseRepository(store),
		RefundRepository:   memory.NewRefundRepository(store),
	}

	server := &http.Server{
		Addr:              appConfig.HTTPAddress,
		Handler:           transporthttp.NewRouter(dependencies),
		ReadHeaderTimeout: 5 * time.Second,
	}

	errorCh := make(chan error, 1)
	go func() {
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			errorCh <- err
		}
	}()

	logger.Info(context.Background(), "server_started", map[string]any{
		"address": appConfig.HTTPAddress,
	})

	shutdownCtx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	select {
	case err := <-errorCh:
		logger.Error(context.Background(), "server_start_failed", map[string]any{
			"error": err.Error(),
		})
		return err
	case <-shutdownCtx.Done():
	}

	ctx, cancel := context.WithTimeout(context.Background(), appConfig.ShutdownTimeout)
	defer cancel()

	if err := server.Shutdown(ctx); err != nil {
		logger.Error(context.Background(), "server_shutdown_failed", map[string]any{
			"error": err.Error(),
		})
		return err
	}

	logger.Info(context.Background(), "server_stopped", nil)
	return nil
}

var _ interfaces.AgentRepository = (*memory.AgentRepository)(nil)
var _ interfaces.PurchaseRepository = (*memory.PurchaseRepository)(nil)
var _ interfaces.RefundRepository = (*memory.RefundRepository)(nil)
