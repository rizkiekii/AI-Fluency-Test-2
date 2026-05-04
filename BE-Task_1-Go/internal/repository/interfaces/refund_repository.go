package interfaces

import (
	"context"

	"gotest/internal/domain/entities"
)

type RefundRepository interface {
	Create(ctx context.Context, refund entities.Refund) error
	FindByID(ctx context.Context, refundID string) (entities.Refund, bool, error)
	ListAll(ctx context.Context) ([]entities.Refund, error)
}
